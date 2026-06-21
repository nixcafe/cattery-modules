{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  cfg = config.${namespace}.desktop.hyprland.theme.caelestia.fcitx;
in
{
  options.${namespace}.desktop.hyprland.theme.caelestia.fcitx = {
    enable = lib.mkEnableOption "caelestia fcitx";
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    ${namespace}.desktop.hyprland = {
      require = [
        "fcitx.fcitx"
      ];
    };

    xdg.configFile = {
      "hypr/fcitx" = {
        source = ./lua;
        recursive = true;
      };
    };
  };
}
