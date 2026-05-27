{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkDefaultEnabled;

  cfg = config.${namespace}.desktop.hyprland.theme.charm-cat.screenshots;
in
{
  options.${namespace}.desktop.hyprland.theme.charm-cat.screenshots = {
    enable = lib.mkEnableOption "charm-cat screenshots";
  };

  config = lib.mkIf cfg.enable {
    ${namespace} = {
      # hyprshot
      desktop.hyprland = {
        addons = {
          hyprshot = mkDefaultEnabled;
        };
        require = [
          "screenshots.screenshots"
        ];
      };
    };

    home.packages = with pkgs; [
      nomacs # image viewer
    ];

    xdg.configFile = {
      # preventing nix gc
      "hypr/screenshots" = {
        source = ./lua;
        recursive = true;
      };
    };
  };
}
