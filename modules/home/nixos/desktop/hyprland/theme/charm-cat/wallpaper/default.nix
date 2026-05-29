{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types;
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  cfg = config.${namespace}.desktop.hyprland.theme.charm-cat.wallpaper;
in
{
  options.${namespace}.desktop.hyprland.theme.charm-cat.wallpaper = {
    enable = lib.mkEnableOption "charm-cat wallpaper";
    settings = mkOption {
      type = types.attrs;
      default = { };
    };
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    ${namespace} = {
      services.awww = {
        enable = true;
      }
      // cfg.settings;
      desktop.hyprland = {
        require = [
          "wallpaper.bind"
        ];
      };
    };

    xdg.configFile = {
      "hypr/wallpaper" = {
        source = ./lua;
        recursive = true;
      };
    };
  };
}
