{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}.module) mkDefaultEnabled;

  cfg = config.${namespace}.room.server-mini;
in
{
  options.${namespace}.room.server-mini = {
    enable = lib.mkEnableOption "room server mini";
    qemu-guest = {
      enable = lib.mkEnableOption "qemu guest";
    };
    cloud-init = {
      enable = lib.mkEnableOption "cloud init";
      network.enable = lib.mkEnableOption "cloud network init";
    };
  };

  config = lib.mkIf cfg.enable {
    ${namespace} = {
      room.basis = mkDefaultEnabled;

      services = {
        inherit (cfg) cloud-init qemu-guest;

        acme = mkDefaultEnabled;
      };
    };
  };
}
