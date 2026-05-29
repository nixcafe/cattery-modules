{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  cfg = config.${namespace}.desktop.hyprland.theme.charm-cat.wlogout;
in
{
  options.${namespace}.desktop.hyprland.theme.charm-cat.wlogout = {
    enable = lib.mkEnableOption "charm-cat wlogout";
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    home.packages = with pkgs; [
      wlogout # logout menu
    ];

    ${namespace}.desktop.hyprland = {
      require = [
        "wlogout.hypr-wlogout"
      ];
    };

    xdg.configFile = {
      "wlogout" = {
        source = ./conf;
        recursive = true;
      };

      "hypr/wlogout" = {
        source = ./lua;
        recursive = true;
      };
    };
  };
}
