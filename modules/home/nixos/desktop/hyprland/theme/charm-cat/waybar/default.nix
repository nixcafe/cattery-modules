{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.desktop.hyprland.theme.charm-cat.waybar;
in
{
  options.${namespace}.desktop.hyprland.theme.charm-cat.waybar = {
    enable = lib.mkEnableOption "charm-cat waybar";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # status bar
      waybar
    ];

    ${namespace}.desktop.hyprland = {
      on."hyprland.start" = {
        execs = [
          "\"waybar\""
        ];
      };
    };

    xdg.configFile = {
      "waybar" = {
        source = ./conf;
        recursive = true;
      };
    };
  };
}
