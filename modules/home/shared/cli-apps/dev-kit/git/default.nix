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
  inherit (pkgs.stdenv) isLinux;
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
      signByDefault = mkOption {
        type = types.bool;
        default = true;
        description = "Whether commits and tags should be signed by default.";
      };
      gpgPath = mkOption {
        type = types.str;
        default = "${pkgs.gnupg}/bin/gpg2";
        defaultText = "\${pkgs.gnupg}/bin/gpg2";
        description = "Path to GnuPG binary to use.";
      };
    };
  };

  cfg = config.${namespace}.cli-apps.dev-kit.git;
in
{
  options.${namespace}.cli-apps.dev-kit.git = with types; {
    enable = lib.mkEnableOption "git";
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
    sendEmail = mkOption {
      type = nullOr (submodule {
        options = {
          smtpserver = mkOption {
            type = nullOr str;
            default = user.email.smtp.host or null;
          };
          smtpserverport = mkOption {
            type = nullOr port;
            default = user.email.smtp.port or 587;
          };
          smtpencryption = mkOption {
            type = nullOr str;
            default = "tls";
          };
          smtpuser = mkOption {
            type = nullOr str;
            default = user.email.userName or cfg.userEmail or null;
          };
          confirm = mkOption {
            type = enum [
              "always" # will always confirm before sending
              "never" # will never confirm before sending
              "cc" # will confirm before sending when send-email has automatically added addresses from the patch to the Cc list
              "compose" # will confirm before sending the first message when using --compose.
              "auto" # is equivalent to cc + compose
            ];
            default = "auto";
          };
        };
      });
      default = null;
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
    extraConfig = mkOption {
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
      # common lib
      libsecret # for git credentials
    ];

    programs = {
      git = {
        inherit (cfg)
          userName
          userEmail
          signing
          ignores
          ;
        enable = true;
        package = pkgs.gitFull;
        lfs.enable = true;
        difftastic.enable = true;
        extraConfig = mkMerge [
          {
            pull.rebase = true;
            rerere.enabled = true;
            column.ui = "auto";
            branch.sort = "-committerdate";
            init.defaultBranch = "main";
          }

          (optionalAttrs (cfg.sendEmail != null) { sendemail = cfg.sendEmail; })

          (optionalAttrs isLinux {
            credential.helper = "/etc/profiles/per-user/$(whoami)/bin/git-credential-libsecret";
          })

          cfg.extraConfig
        ];
      } // cfg.extraOptions;
      gh.enable = true;
      gitui.enable = true;
    };

    home.shellAliases = {
      diff = "difft";
    };

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      xdg.config.files = [
        "gh/hosts.yml"
      ];
      xdg.cache.directories = [ "gh" ];
    };
  };

}
