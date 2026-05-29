{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  cfg = config.${namespace}.desktop.hyprland.theme.charm-cat.fcitx;
in
{
  options.${namespace}.desktop.hyprland.theme.charm-cat.fcitx = {
    enable = lib.mkEnableOption "charm-cat fcitx";
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    ${namespace}.desktop.hyprland = {
      require = [
        "fcitx/fcitx"
      ];
    };

    xdg.configFile = {
      # preventing nix gc
      "hypr/fcitx" = {
        source = ./lua;
        recursive = true;
      };
    };
  };
}
