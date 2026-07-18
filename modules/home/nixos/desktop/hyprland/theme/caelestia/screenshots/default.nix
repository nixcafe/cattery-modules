{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib.${namespace}.module) mkDefaultEnabled;
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  cfg = config.${namespace}.desktop.hyprland.theme.caelestia.screenshots;
in
{
  options.${namespace}.desktop.hyprland.theme.caelestia.screenshots = {
    enable = lib.mkEnableOption "caelestia screenshots";
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    ${namespace}.desktop.hyprland = {
      addons = {
        hyprshot = mkDefaultEnabled;
      };
      require = [
        "screenshots.screenshots"
      ];
    };

    xdg.configFile = {
      "hypr/screenshots" = {
        source = ./lua;
        recursive = true;
      };
    };
  };
}
