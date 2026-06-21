{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types mkDefault;
  inherit (lib.${namespace}) mkDefaultEnabled;
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  cfg = config.${namespace}.desktop.hyprland.theme.caelestia;
in
{
  options.${namespace}.desktop.hyprland.theme.caelestia = {
    enable = lib.mkEnableOption "caelestia theme";
    settings = mkOption {
      type = types.attrs;
      default = { };
      description = "programs.caelestia settings (see https://github.com/caelestia-dots/shell#configuring)";
    };
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    ${namespace}.desktop.hyprland = {
      enable = mkDefault true;
      theme.caelestia = {
        convention = mkDefaultEnabled;
        audio = mkDefaultEnabled;
        terminal = mkDefaultEnabled;
        file-manager = mkDefaultEnabled;
        fcitx = mkDefaultEnabled;
        idle = mkDefaultEnabled;
        screenshots = mkDefaultEnabled;
      };
    };
  };
}
