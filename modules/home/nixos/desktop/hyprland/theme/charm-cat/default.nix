{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib) mkDefault;
  inherit (lib.${namespace}.module) mkDefaultEnabled;
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  cfg = config.${namespace}.desktop.hyprland.theme.charm-cat;
in
{
  options.${namespace}.desktop.hyprland.theme.charm-cat = {
    enable = lib.mkEnableOption "charm-cat theme";
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    ${namespace}.desktop.hyprland = {
      enable = mkDefault true;
      theme.charm-cat = {
        audio = mkDefaultEnabled;
        convention = mkDefaultEnabled;
        fcitx = mkDefaultEnabled;
        file-manager = mkDefaultEnabled;
        launcher = mkDefaultEnabled;
        lock-screen = mkDefaultEnabled;
        notification = mkDefaultEnabled;
        screenshots = mkDefaultEnabled;
        terminal = mkDefaultEnabled;
        vscode = mkDefaultEnabled;
        wallpaper = mkDefaultEnabled;
        waybar = mkDefaultEnabled;
        wlogout = mkDefaultEnabled;
      };
    };
  };
}
