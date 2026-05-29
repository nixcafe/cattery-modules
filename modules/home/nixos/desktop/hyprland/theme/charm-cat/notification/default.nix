{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  cfg = config.${namespace}.desktop.hyprland.theme.charm-cat.notification;
in
{
  options.${namespace}.desktop.hyprland.theme.charm-cat.notification = {
    enable = lib.mkEnableOption "charm-cat notification";
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    home.packages = with pkgs; [
      libnotify
    ];

    services.mako = {
      enable = true;
      extraConfig = builtins.readFile ./conf/config.ini;
    };

    ${namespace}.desktop.hyprland = {
      require = [
        "mako.mako"
      ];
    };

    xdg.configFile = {
      "hypr/mako" = {
        source = ./lua;
        recursive = true;
      };
    };
  };
}
