{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkDefaultEnabled;

  cfg = config.${namespace}.desktop.lightdm;
in
{
  options.${namespace}.desktop.lightdm = {
    enable = lib.mkEnableOption "lightdm";
  };

  config = lib.mkIf cfg.enable {
    ${namespace}.desktop.addons.xdg-portal = mkDefaultEnabled;

    services.xserver = {
      enable = true;
      displayManager.lightdm.enable = true;
    };
  };

}
