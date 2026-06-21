{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types;
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  cfgParent = config.${namespace}.desktop.hyprland.theme.caelestia;
  cfg = cfgParent.convention;

  defaultSettings = {
    general = {
      apps = {
        terminal = [ "kitty" ];
        audio = [ "pavucontrol" ];
        playback = [ "mpv" ];
        explorer = [ "thunar" ];
      };
    };
    session = {
      commands = {
        logout = [
          "hyprctl"
          "dispatch"
          "hl.dsp.exit()"
        ];
        shutdown = [
          "systemctl"
          "poweroff"
        ];
        reboot = [
          "systemctl"
          "reboot"
        ];
        hibernate = [
          "systemctl"
          "hibernate"
        ];
      };
    };
  };

  mergedSettings = lib.recursiveUpdate defaultSettings cfg.settings;

  wsaction = pkgs.writeShellApplication {
    name = "wsaction";
    runtimeInputs = with pkgs; [
      jq
      hyprland
    ];
    text = ''
      group=""
      case "$1" in -g) group=1; shift ;; esac

      if [ $# -ne 2 ]; then
          echo "Usage: wsaction [-g] <workspace|movetoworkspace> <num>"
          exit 1
      fi

      active_ws=$(hyprctl -j activeworkspace 2>/dev/null | jq -r '.id')
      if [ -z "$active_ws" ]; then
          echo "Error: failed to get active workspace"
          exit 1
      fi

      case "$1" in
          workspace)        dsp="hl.dsp.focus" ;;
          movetoworkspace)  dsp="hl.dsp.window.move" ;;
          *)                echo "Unknown command: $1"; exit 1 ;;
      esac

      if [ -n "$group" ]; then
          ws=$(( ($2 - 1) * 10 + active_ws % 10 ))
      else
          ws=$(( (active_ws - 1) / 10 * 10 + $2 ))
      fi

      hyprctl dispatch "$(printf '%s({ workspace = %d })' "$dsp" "$ws")"
    '';
  };
in
{
  options.${namespace}.desktop.hyprland.theme.caelestia.convention = {
    enable = lib.mkEnableOption "caelestia convention";
    settings = mkOption {
      type = types.attrs;
      default = cfgParent.settings or { };
      description = "programs.caelestia settings (see https://github.com/caelestia-dots/shell#configuring)";
    };
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = cfgParent.persistence;
    };
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    programs.caelestia = {
      enable = true;
      cli.enable = true;
      systemd.enable = false;
      settings = mergedSettings;
    };

    home.packages = with pkgs; [
      app2unit
      cliphist
      fuzzel
      hyprpicker
      playerctl
      trash-cli
      wl-clipboard
      wsaction
      ydotool
      gnome-keyring
      polkit_gnome
      geoclue2
      gammastep
      bluez
    ];

    ${namespace} = {
      desktop.hyprland = {
        require = [
          "convention.base"
          "convention.bind-operate"
          "convention.monitor"
          "convention.rules"
          "convention.style"
        ];

        on = {
          "hyprland.start" = {
            execs = [
              "\"gnome-keyring-daemon --start --components=secrets\""
              "\"polkit-gnome-authentication-agent-1\""
              "\"wl-paste --type text --watch cliphist store\""
              "\"wl-paste --type image --watch cliphist store\""
              "\"sleep 1 && gammastep\""
              "\"mpris-proxy\""
              "\"caelestia resizer -d\""
              "\"caelestia shell -d\""
            ];
          };
        };
      };

      system.impermanence = lib.mkIf cfg.persistence {
        xdg.cache.directories = [
          "caelestia"
        ];
        xdg.state.directories = [
          "caelestia"
        ];
        xdg.config.directories = [
          "caelestia"
        ];
      };
    };

    xdg.configFile = {
      "hypr/convention" = {
        source = ./lua;
        recursive = true;
      };
    };
  };
}
