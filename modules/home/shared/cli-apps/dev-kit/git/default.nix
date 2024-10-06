{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;
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
        extraConfig = {
          pull.rebase = "true";
          rerere.enabled = "true";
          column.ui = "auto";
          branch.sort = "-committerdate";
          init.defaultBranch = "main";
        };
      };
      gh.enable = true;
      gitui.enable = true;
    };
  };

}
