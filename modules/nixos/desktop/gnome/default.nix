{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkDefaultEnabled;

  cfg = config.${namespace}.desktop.gnome;
in
{
  options.${namespace}.desktop.gnome = {
    enable = lib.mkEnableOption "gnome";
  };

  config = lib.mkIf cfg.enable {
    ${namespace}.desktop.addons.xdg-portal = mkDefaultEnabled;

    services.xserver = {
      enable = true;

      desktopManager.gnome.enable = true;
      # GNOME Display Manager
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    };

    programs.seahorse.enable = true;
  };

}
