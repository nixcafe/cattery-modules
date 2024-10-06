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
        default = user.signKey or null;
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
      default = user.nickname or null;
    };
    userEmail = mkOption {
      type = nullOr str;
      default = user.email or null;
    };
    signing = mkOption {
      type = nullOr signModule;
      default = if ((user.signKey or null) != null) then { } else null;
    };
    sendEmail = mkOption {
      type = nullOr (submodule {
        options = {
          smtpserver = mkOption {
            type = nullOr str;
            default = null;
          };
          smtpserverport = mkOption {
            type = nullOr str;
            default = "587";
          };
          smtpencryption = mkOption {
            type = nullOr str;
            default = "tls";
          };
          smtpuser = mkOption {
            type = nullOr str;
            default = cfg.userEmail or null;
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
    extraConfig = mkOption {
      type = attrs;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      git = {
        inherit (cfg) userName userEmail signing;
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

          cfg.extraConfig
        ];
      };
      gh.enable = true;
      gitui.enable = true;
    };
  };

}
