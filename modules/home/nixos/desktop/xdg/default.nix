{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;
  inherit (pkgs.stdenv) isLinux;

  cfg = config.${namespace}.desktop.xdg;
in
{
  options.${namespace}.desktop.xdg = with types; {
    enable = lib.mkEnableOption "xdg";
    app = {
      audio = mkOption {
        type = listOf str;
        default = [
          "mpv.desktop"
        ];
      };
      browser = mkOption {
        type = listOf str;
        default = [
          "cfg.app.browser;"
          "chromium.desktop"
          "google-chrome.desktop"
        ];
      };
      editor = mkOption {
        type = listOf str;
        default = [
          "code-insiders.desktop"
          "code.desktop"
        ];
      };
      image = mkOption {
        type = listOf str;
        default = [
          "org.nomacs.ImageLounge.desktop"
          "imv-dir.desktop"
        ];
      };
      video = mkOption {
        type = listOf str;
        default = [
          "mpv.desktop"
        ];
      };
      mailto = mkOption {
        type = listOf str;
        default = [
          "thunderbird.desktop"
        ];
      };
      calendar = mkOption {
        type = listOf str;
        default = [
          "thunderbird.desktop"
        ];
      };
    };
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    home.packages = with pkgs; [
      xdg-utils
      xdg-user-dirs
    ];

    xdg = {
      enable = true;

      userDirs = {
        enable = true;
        createDirectories = true;
      };

      mimeApps = {
        enable = true;
        # see: https://developer.mozilla.org/en-US/docs/Web/HTTP/MIME_types/Common_types
        # and: https://mimetype.io/all-types
        # not necessarily comprehensive but sufficient.
        defaultApplications = {
          # audio
          "audio/*" = cfg.app.audio;
          "audio/aac" = cfg.app.audio;
          "audio/flac" = cfg.app.audio;
          # browser
          "application/json" = cfg.app.browser;
          "application/ld+json" = cfg.app.browser;
          "application/pdf" = cfg.app.browser;
          "image/svg+xml" = cfg.app.browser;
          "application/xhtml+xml" = cfg.app.browser;
          "application/xml" = cfg.app.browser;
          "application/atom+xml" = cfg.app.browser;
          "application/rdf+xml" = cfg.app.browser;
          "application/rss+xml" = cfg.app.browser;
          "application/x-extension-htm" = cfg.app.browser;
          "application/x-extension-html" = cfg.app.browser;
          "application/x-extension-shtml" = cfg.app.browser;
          "application/x-extension-xhtml" = cfg.app.browser;
          "application/x-extension-xht" = cfg.app.browser;
          "x-scheme-handler/http" = cfg.app.browser;
          "x-scheme-handler/https" = cfg.app.browser;
          "x-scheme-handler/ftp" = cfg.app.browser;
          "x-scheme-handler/chrome" = cfg.app.browser;
          "x-scheme-handler/about" = cfg.app.browser;
          # editor
          "text/css" = cfg.app.editor;
          "text/csv" = cfg.app.editor;
          "text/html" = cfg.app.editor;
          "text/javascript" = cfg.app.editor;
          "text/markdown" = cfg.app.editor;
          "text/plain" = cfg.app.editor;
          # image
          "image/*" = cfg.app.image;
          "image/avif" = cfg.app.image;
          "image/bmp" = cfg.app.image;
          "image/gif" = cfg.app.image;
          "image/jpeg" = cfg.app.image;
          "image/pjpeg" = cfg.app.image;
          "image/png" = cfg.app.image;
          "image/webp" = cfg.app.image;
          # video
          "video/*" = cfg.app.video;
          "video/mp4" = cfg.app.video;
          "video/webm" = cfg.app.video;
          "video/x-m4v" = cfg.app.video;
          "video/x-matroska" = cfg.app.video; # .mkv
          # mailto
          "x-scheme-handler/mailto" = cfg.app.mailto;
          "x-scheme-handler/mid" = cfg.app.mailto;
          "message/rfc822" = cfg.app.mailto; # https://www.w3.org/Protocols/rfc1341/7_3_Message.html
          # calendar
          "text/calendar" = cfg.app.calendar;
          "application/x-extension-ics" = cfg.app.calendar;
          "x-scheme-handler/webcal" = cfg.app.calendar;
          "x-scheme-handler/webcals" = cfg.app.calendar;
        };
      };
    };
  };
}
