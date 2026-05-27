{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.desktop.hyprland.theme.charm-cat.fcitx;
in
{
  options.${namespace}.desktop.hyprland.theme.charm-cat.fcitx = {
    enable = lib.mkEnableOption "charm-cat fcitx";
  };

  config = lib.mkIf cfg.enable {
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
