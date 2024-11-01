{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.nix.home-manager;
in
{
  options.${namespace}.cli-apps.nix.home-manager = {
    enable = lib.mkEnableOption "home manager";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      # let home-manager install and manage itself
      home-manager.enable = true;
    };

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      xdg.cache.directories = [ "nix" ];
      xdg.data.directories = [ "nix" ];
    };
  };

}
