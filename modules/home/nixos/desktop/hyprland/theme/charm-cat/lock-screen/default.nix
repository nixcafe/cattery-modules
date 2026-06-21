{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib.${namespace}) mkDefaultEnabled;
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  cfg = config.${namespace}.desktop.hyprland.theme.charm-cat.lock-screen;
  lockCmd = "pidof hyprlock || hyprlock";
in
{
  options.${namespace}.desktop.hyprland.theme.charm-cat.lock-screen = {
    enable = lib.mkEnableOption "charm-cat lock screen";
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    ${namespace} = {
      desktop.hyprland = {
        addons = {
          hyprlock = mkDefaultEnabled;
        };
        require = [
          "lock-screen.lock"
          "lock-screen.idle"
        ];
      };
    };

    home.packages = [ pkgs.hypridle ];

    # hyprlock
    programs.hyprlock = {
      settings = {
        source = [ "${./lua/hyprlock.conf}" ];
      };
    };

    # hypridle config (started via exec-once in lock-screen/idle.lua, not systemd)
    xdg.configFile."hypr/hypridle.conf".text = ''
      general {
        lock_cmd = ${lockCmd}
        before_sleep_cmd = ${lockCmd}
      }

      listener {
        timeout = 180
        on-timeout = ${lockCmd}
      }

      listener {
        timeout = 240
        on-timeout = hyprctl dispatch 'hl.dsp.dpms({ action = "off" })'
        on-resume = hyprctl dispatch 'hl.dsp.dpms({ action = "on" })'
      }
    '';

    xdg.configFile = {
      "hypr/lock-screen" = {
        source = ./lua;
        recursive = true;
      };
    };
  };
}
