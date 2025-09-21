{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.apps.game.gale;
in
{
  options.${namespace}.apps.game.gale = {
    enable = lib.mkEnableOption "gale";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.gale
    ];

    ${namespace}.home.extraOptions = {
      ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
        xdg = {
          cache.directories = [
            "com.kesomannen.gale"
          ];
          data.directories = [
            "com.kesomannen.gale"
          ];
        };
      };
    };
  };

}
