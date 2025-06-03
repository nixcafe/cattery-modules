{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.system.network;
in
{
  options.${namespace}.system.network = {
    enable = lib.mkEnableOption "network";
  };

  config = lib.mkIf cfg.enable {
    # Easiest to use and most distros use this by default.
    networking.networkmanager.enable = true;

    # Both systemd-networkd and NetworkManager can exist in parallel on the same machine,
    # when they manage a distinct set of interfaces.
    # If upstream connectivity is managed by NetworkManager
    # (for example, NM handles wifi and networkd does VM networking),
    # set systemd.network.wait-online.enable to false
    # so that boot isn't blocked on connectivity that networkd will never provide.

    # systemd.network.wait-online.enable = false;
  };

}
