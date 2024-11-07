{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib)
    optional
    mkOption
    types
    any
    ;
  inherit (pkgs.stdenv) isLinux;

  cfg = config.${namespace}.apps.browser;
in
{
  options.${namespace}.apps.browser = with types; {
    enable = lib.mkEnableOption "browser";
    needs = mkOption {
      type = listOf (enum [
        "firefox"
        "chromium"
        "chrome"
      ]);
      default = [ "firefox" ];
    };
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    # the linux browser (TM)
    programs = {
      firefox = {
        enable = any (x: x == "firefox") cfg.needs;
        package = pkgs.firefox-devedition-bin;
      };

      chromium = {
        enable = any (x: x == "chromium") cfg.needs;
        package = pkgs.ungoogled-chromium;
        commandLineArgs = [
          "--ozone-platform=wayland"
          "--enable-wayland-ime"
        ];
      };

      # google chrome
      # source code: https://github.com/nix-community/home-manager/blob/master/modules/programs/chromium.nix
      google-chrome = {
        enable = any (x: x == "chrome") cfg.needs;
        commandLineArgs = [
          "--ozone-platform=wayland"
          "--enable-wayland-ime"
        ];
      };
    };

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      directories = optional (any (x: x == "firefox") cfg.needs) ".mozilla";
      xdg.config.directories = builtins.filter (x: x != "") (
        map (
          x:
          if x == "chromium" then
            "chromium"
          else if x == "chrome" then
            "google-chrome"
          else
            ""
        ) cfg.needs
      );
      xdg.cache.directories = builtins.filter (x: x != "") (
        map (
          x:
          if x == "firefox" then
            "mozilla/firefox"
          else if x == "chromium" then
            "chromium"
          else if x == "chrome" then
            "google-chrome"
          else
            ""
        ) cfg.needs
      );
    };

  };

}
