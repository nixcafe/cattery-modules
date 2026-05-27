{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.desktop.hyprland.theme.charm-cat.file-manager;
in
{
  options.${namespace}.desktop.hyprland.theme.charm-cat.file-manager = {
    enable = lib.mkEnableOption "charm-cat file manager";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ thunar ];

    ${namespace}.desktop.hyprland = {
      require = [
        "file-manager.thunar"
      ];
    };

    xdg.configFile = {
      # preventing nix gc
      "hypr/file-manager" = {
        source = ./lua;
        recursive = true;
      };
    };
  };
}
