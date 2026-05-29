{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  cfg = config.${namespace}.desktop.hyprland.addons.hypridle;
in
{
  options.${namespace}.desktop.hyprland.addons.hypridle = {
    enable = lib.mkEnableOption "hypridle";
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    services.hypridle = {
      enable = true;
    };
  };
}
