{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.shell.atuin;
in
{
  options.${namespace}.cli-apps.shell.atuin = {
    enable = lib.mkEnableOption "atuin";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      # zsh history is just too smol
      atuin = {
        enable = true;
        settings = {
          auto_sync = true; # remember to login with `atuin login -u <USERNAME>`
          enter_accept = true;
          style = "compact";
        };
      };
    };

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      xdg.data.directories = [ "atuin" ];
    };
  };

}
