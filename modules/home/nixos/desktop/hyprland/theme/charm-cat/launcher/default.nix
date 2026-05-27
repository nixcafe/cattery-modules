{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.desktop.hyprland.theme.charm-cat.launcher;
in
{
  options.${namespace}.desktop.hyprland.theme.charm-cat.launcher = {
    enable = lib.mkEnableOption "charm-cat launcher";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ ulauncher ];

    ${namespace}.desktop.hyprland = {
      require = [
        "ulauncher.ulauncher"
      ];
    };

    xdg.configFile = {
      # preventing nix gc
      "hypr/ulauncher" = {
        source = ./lua;
        recursive = true;
      };
    };
  };
}
