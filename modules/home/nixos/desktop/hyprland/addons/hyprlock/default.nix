{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  cfg = config.${namespace}.desktop.hyprland.addons.hyprlock;
in
{
  options.${namespace}.desktop.hyprland.addons.hyprlock = {
    enable = lib.mkEnableOption "hyprlock";
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    programs.hyprlock = {
      enable = true;
    };
  };
}
