{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types any;
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

      # browserpass for password management
      browserpass.enable = true;
    };
  };

}
