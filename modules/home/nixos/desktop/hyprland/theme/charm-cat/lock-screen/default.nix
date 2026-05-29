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
      # hyprlock and hypridle
      desktop.hyprland = {
        addons = {
          hyprlock = mkDefaultEnabled;
          hypridle = mkDefaultEnabled;
        };
        require = [
          "lock-screen.lock"
        ];
      };
    };

    # hyprlock
    programs.hyprlock = {
      settings = {
        source = [ "${./lua/hyprlock.conf}" ];
      };
    };

    # hypridle
    services.hypridle = {
      settings = {
        general = {
          lock_cmd = lockCmd;
          before_sleep_cmd = lockCmd;
        };

        listener = [
          # listener conf 1
          {
            timeout = 180; # 3mins
            on-timeout = lockCmd;
          }
          # listener conf 2
          {
            timeout = 240; # 4mins
            # sets all monitors’ DPMS status
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };

    xdg.configFile = {
      # preventing nix gc
      "hypr/lock-screen" = {
        source = ./lua;
        recursive = true;
      };
    };
  };
}
