{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  cfg = config.${namespace}.desktop.hyprland.theme.charm-cat.file-manager;
in
{
  options.${namespace}.desktop.hyprland.theme.charm-cat.file-manager = {
    enable = lib.mkEnableOption "charm-cat file manager";
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    home.packages = with pkgs; [ kdePackages.dolphin ];

    ${namespace}.desktop.hyprland = {
      require = [
        "file-manager.dolphin"
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
