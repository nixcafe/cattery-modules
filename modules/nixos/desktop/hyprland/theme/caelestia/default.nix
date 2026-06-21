{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkDefault;

  cfg = config.${namespace}.desktop.hyprland.theme.caelestia;
in
{
  options.${namespace}.desktop.hyprland.theme.caelestia = {
    enable = lib.mkEnableOption "caelestia theme";
  };

  config = lib.mkIf cfg.enable {
    # sddm for login
    services.displayManager.sddm = {
      enable = true;
      autoNumlock = true;
      wayland.enable = true;
    };

    # hyprland compositor
    ${namespace}.desktop.hyprland = {
      enable = mkDefault true;
    };
  };
}
