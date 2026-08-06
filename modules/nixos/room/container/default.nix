{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}.module) mkDefaultEnabled;

  cfg = config.${namespace}.room.container;
in
{
  options.${namespace}.room.container = {
    enable = lib.mkEnableOption "room container";
  };

  config = lib.mkIf cfg.enable {
    ${namespace} = {
      room.basis = mkDefaultEnabled;

      services = {
        acme = mkDefaultEnabled;
      };
    };

    boot.isContainer = true;

    # Containers have no wireless hardware. NetworkManager force-enables
    # wpa_supplicant as its wifi backend, which fails to start without
    # /dev/rfkill in a container, so stop it.
    systemd.services.wpa_supplicant.enable = lib.mkForce false;
  };
}
