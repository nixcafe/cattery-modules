{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkDefaultEnabled;

  cfg = config.${namespace}.room.desktop.basis;
in
{
  options.${namespace}.room.desktop.basis = {
    enable = lib.mkEnableOption "room desktop basis";
  };

  config = lib.mkIf cfg.enable {
    ${namespace} = {
      room.basis = mkDefaultEnabled;

      system = {
        automount = mkDefaultEnabled;
        fcitx5 = mkDefaultEnabled;
        network.wireless = mkDefaultEnabled;
        peripherals = mkDefaultEnabled;
      };

      desktop = {
        addons = {
          # wayland support
          chromium-support = mkDefaultEnabled;
        };
      };

      # shared
      cli-apps = {
        security.fido2 = mkDefaultEnabled;
      };
      system = {
        fonts = mkDefaultEnabled;
      };
    };
  };
}
