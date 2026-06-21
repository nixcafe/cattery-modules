{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  cfg = config.${namespace}.desktop.hyprland.theme.caelestia.idle;
in
{
  options.${namespace}.desktop.hyprland.theme.caelestia.idle = {
    enable = lib.mkEnableOption "caelestia idle";
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    home.packages = [ pkgs.hypridle ];

    ${namespace}.desktop.hyprland = {
      require = [
        "idle.idle"
      ];
    };

    # hypridle config (started via exec_cmd in idle/idle.lua, not systemd)
    xdg.configFile."hypr/hypridle.conf".text = ''
      general {
        lock_cmd = caelestia shell lock lock
        before_sleep_cmd = caelestia shell lock lock
      }
    '';

    xdg.configFile = {
      "hypr/idle" = {
        source = ./lua;
        recursive = true;
      };
    };
  };
}
