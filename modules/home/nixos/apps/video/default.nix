{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;

  cfg = config.${namespace}.apps.video;
in
{
  options.${namespace}.apps.video = {
    enable = lib.mkEnableOption "video";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    home.packages = with pkgs; [
      syncplay # syncs media playback
      vlc # media player
    ];

    programs = {
      # player for things that vlc can't
      mpv.enable = true;

      # recording tool (lol)
      obs-studio.enable = true;
    };

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      xdg = {
        data.directories = [
          "vlc"
        ];
        cache.directories = [
          "mpv"
        ];
        config.directories = [
          "Syncplay"
          "vlc"
          "mpv"
          "obs-studio"
        ];
      };
    };
  };

}
