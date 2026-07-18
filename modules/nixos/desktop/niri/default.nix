{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}.module) mkDefaultEnabled;

  cfg = config.${namespace}.desktop.niri;
in
{
  options.${namespace}.desktop.niri = {
    enable = lib.mkEnableOption "niri";
  };

  config = lib.mkIf cfg.enable {
    ${namespace} = {
      desktop.addons.xdg-portal = mkDefaultEnabled;
    };

    # niri compositor and wayland session
    programs.niri.enable = true;
  };
}
