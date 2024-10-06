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
    signKey = mkOption {
      type = nullOr str;
      default = user.signKey or null;
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
        inherit (cfg) userName userEmail;
        enable = true;
        package = pkgs.gitFull;
        lfs.enable = true;
        difftastic.enable = true;
        signing = {
          key = cfg.signKey;
          signByDefault = cfg.signKey != null;
        };
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
