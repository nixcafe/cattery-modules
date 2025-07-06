{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    mkMerge
    optionalAttrs
    ;
  inherit (config.${namespace}) user;

  signModule = types.submodule {
    options = {
      key = mkOption {
        type = types.nullOr types.str;
        default = user.gpg.signKey or null;
        description = ''
          The default GPG signing key fingerprint.

          Set to `null` to let GnuPG decide what signing key
          to use depending on commit’s author.
        '';
      };
      backend = mkOption {
        type = types.nullOr (
          types.enum [
            "gpg"
            "gpgsm"
            "ssh"
          ]
        );
        default = "gpg";
        description = ''
          The signing method to use when signing commits and tags.
          Valid values are `openpgp` (OpenPGP/GnuPG), `ssh` (SSH), and `x509` (X.509 certificates).
        '';
      };
      behavior = mkOption {
        type = types.nullOr (
          types.enum [
            "drop"
            "keep"
            "own"
            "force"
          ]
        );
        default = "own";
        description = ''
          The signing.behavior configuration option has four different options for what to
          do with signing commits on modification of a change (e.g., rebasing or edits).

          drop: do not automatically sign; if a change was signed before modification, drop that signing after modification.
          keep: if a change was signed before modification, and it was authored by you, attempt to sign it again after the modification.
          own: sign all commits that were authored by you when you modify them.
          force: sign all commits after modification, always, even if you are not the author.

          Instead of signing all commits during creation when signing.behavior is set to own, 
          the git.sign-on-push configuration can be used to sign commits only upon running jj git push. 
          All mutable unsigned commits being pushed will be signed prior to pushing. 
        '';
      };
      signer = mkOption {
        type = types.str;
        default =
          if (cfg.signing.backend == "gpg") then
            "${pkgs.gnupg}/bin/gpg2"
          else if (cfg.signing.backend == "gpgsm") then
            "${pkgs.gnupg}/bin/gpgsm"
          else
            "${pkgs.openssh}/bin/ssh-keygen";
      };
    };
  };

  cfg = config.${namespace}.cli-apps.dev-kit.jujutsu;
in
{
  options.${namespace}.cli-apps.dev-kit.jujutsu = with types; {
    enable = lib.mkEnableOption "jujutsu";
    userName = mkOption {
      type = nullOr str;
      default = user.realName or null;
    };
    userEmail = mkOption {
      type = nullOr str;
      default = user.email.address or null;
    };
    signing = mkOption {
      type = nullOr signModule;
      default = if ((user.gpg.signKey or null) != null) then { } else null;
    };
    ignores = mkOption {
      type = listOf str;
      default = [ ];
      example = [
        "*~"
        "*.swp"
      ];
      description = "List of paths that should be globally ignored.";
    };
    settings = mkOption {
      type = attrs;
      default = { };
    };
    extraOptions = mkOption {
      type = attrs;
      default = { };
    };
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # tui
      lazyjj
      # jjui
      # jj-fzf
    ];

    programs = {
      jujutsu = {
        enable = true;

        settings = mkMerge [
          {
            user = mkMerge [
              (optionalAttrs (cfg.userName != null) {
                name = cfg.userName;
              })
              (optionalAttrs (cfg.userEmail != null) {
                email = cfg.userEmail;
              })
            ];

            git = {
              auto-local-bookmark = true;

              abandon-unreachable-commits = true;

              # Sign commits on push (similar to git's behavior)
              sign-on-push = mkMerge [
                (optionalAttrs (cfg.signing != null && cfg.signing.behavior == "own") true)
              ];
            };

            ui = {
              default-command = [
                "log"
                "--patch"
                "--summary"
              ];
            };

            signing = mkMerge [
              (optionalAttrs (cfg.signing != null) {
                inherit (cfg.signing) backend behavior key;

                backends = mkMerge [
                  (optionalAttrs (cfg.signing.backend == "gpg") {
                    gpg = {
                      program = cfg.signing.signer;
                    };
                  })

                  (optionalAttrs (cfg.signing.backend == "gpgsm") {
                    gpgsm = {
                      program = cfg.signing.signer;
                    };
                  })

                  (optionalAttrs (cfg.signing.backend == "ssh") {
                    ssh = {
                      program = cfg.signing.signer;
                      allowed-signers = "${user.home}/.ssh/allowed_signers";
                    };
                  })
                ];
              })
            ];

            core = {
              ignore = cfg.ignores;
            };
          }

          cfg.settings
        ];
      } // cfg.extraOptions;
    };
  };

}
