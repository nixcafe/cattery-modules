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

  mkScript =
    name: file:
    pkgs.writeShellApplication {
      inherit name;

      runtimeInputs = with pkgs; [
        bash
        coreutils
        findutils
        awww
      ];

      text = builtins.readFile file;
    };

  scripts = {
    randomize = mkScript "awww-randomize" ./scripts/randomize.sh;
    randomize-multi = mkScript "awww-randomize-multi" ./scripts/randomize_multi.sh;
  };

  cfg = config.${namespace}.services.awww;
in
{
  options.${namespace}.services.awww = {
    enable = lib.mkEnableOption "charm-cat wallpaper";
    mode = mkOption {
      type = types.enum [
        "randomize"
        "randomize-multi"
      ];
      default = "randomize-multi";
      description = "Rotation mode determining which script execution logic to apply.";
    };
    wallpaperDir = mkOption {
      type = types.str;
      default = "${config.home.homeDirectory}/Pictures/Wallpapers";
      description = "Absolute path to the wallpaper directory.";
    };
    interval = mkOption {
      type = types.str;
      default = "300";
      description = "Wallpaper rotation interval in seconds.";
    };
    resizeType = mkOption {
      type = types.enum [
        "no"
        "crop"
        "fit"
        "stretch"
      ];
      default = "crop";
      description = "Resize type for wallpapers.";
    };
    transition = mkOption {
      type = types.submodule {
        options = {

          type = mkOption {
            type = types.str;
            default = "simple";
            description = ''
              Transition type passed directly to awww.

              Supported by awww:
              none, simple, fade, left, right, top, bottom,
              wipe, wave, grow, center, any, outer, random
            '';
          };

          fps = mkOption {
            type = types.int;
            default = 30;
            description = "Frame rate for transition animation.";
          };

          step = mkOption {
            type = types.int;
            default = 90;
            description = "How fast transition approaches target image.";
          };

          duration = mkOption {
            type = types.nullOr types.int;
            default = null;
            description = "Optional transition duration (seconds). Only works with non-simple transitions.";
          };

          angle = mkOption {
            type = types.nullOr types.int;
            default = null;
            description = "Angle for wipe/wave transitions.";
          };

          pos = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = "Position for grow/outer transitions (e.g. center, top-left, 0.5,0.5).";
          };

          bezier = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = "Bezier curve for fade transitions (e.g. 0.4,0,0.2,1).";
          };

          wave = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = "Wave size for wave transition (e.g. 20,20).";
          };

          invertY = mkOption {
            type = types.bool;
            default = false;
            description = "Invert Y axis for transition position.";
          };
        };
      };

      default = { };
    };
    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "--no-cache"
        "--layer"
        "bottom"
      ];
      description = ''
        Options given to awww-daemon when the service is run.

        See `awww-daemon --help` for more information.
      '';
    };
    extraOptions = mkOption {
      type = types.attrs;
      default = { };
    };
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    services.awww = {
      inherit (cfg) extraArgs;

      enable = true;
    }
    // cfg.extraOptions;

    systemd.user.services.awww-loop = {
      Unit = {
        Description = "Awww Wallpaper Auto-Rotation Service (${cfg.mode} mode)";
        After = [
          "graphical-session.target"
          "awww.service"
        ];
        Requires = [ "awww.service" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        Type = "simple";

        Environment = [
          "WALLPAPER_DIR=${cfg.wallpaperDir}"
          "INTERVAL=${cfg.interval}"
          "RESIZE_TYPE=${cfg.resizeType}"

          "AWWW_TRANSITION=${cfg.transition.type}"
          "AWWW_TRANSITION_FPS=${toString cfg.transition.fps}"
          "AWWW_TRANSITION_STEP=${toString cfg.transition.step}"
        ]
        ++ lib.optional (
          cfg.transition.duration != null
        ) "AWWW_TRANSITION_DURATION=${toString cfg.transition.duration}"
        ++ lib.optional (
          cfg.transition.angle != null
        ) "AWWW_TRANSITION_ANGLE=${toString cfg.transition.angle}"
        ++ lib.optional (cfg.transition.pos != null) "AWWW_TRANSITION_POS=${cfg.transition.pos}"
        ++ lib.optional (cfg.transition.bezier != null) "AWWW_TRANSITION_BEZIER=${cfg.transition.bezier}"
        ++ lib.optional (cfg.transition.wave != null) "AWWW_TRANSITION_WAVE=${cfg.transition.wave}"
        ++ lib.optional cfg.transition.invertY "INVERT_Y=1";

        ExecStart = lib.getExe scripts.${cfg.mode};
        Restart = "on-failure";
        RestartSec = 3;
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
