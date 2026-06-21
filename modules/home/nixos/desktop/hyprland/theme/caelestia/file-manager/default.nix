{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  cfg = config.${namespace}.desktop.hyprland.theme.caelestia.file-manager;
in
{
  options.${namespace}.desktop.hyprland.theme.caelestia.file-manager = {
    enable = lib.mkEnableOption "caelestia file manager";
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    home.packages = with pkgs; [
      thunar
      thunar-archive-plugin
      thunar-volman
    ];

    ${namespace}.desktop.hyprland = {
      require = [
        "file-manager.thunar"
      ];
    };

    xdg.configFile = {
      "hypr/file-manager" = {
        source = ./lua;
        recursive = true;
      };
    };
  };
}
