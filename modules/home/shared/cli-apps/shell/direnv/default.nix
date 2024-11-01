{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.shell.direnv;
in
{
  options.${namespace}.cli-apps.shell.direnv = {
    enable = lib.mkEnableOption "direnv";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      xdg.data.directories = [ "direnv" ];
    };
  };

}
