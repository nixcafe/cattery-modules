{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkDefault;
  inherit (lib.${namespace}.module) mkDefaultEnabled;

  cfg = config.${namespace}.room.server;
in
{
  options.${namespace}.room.server = {
    enable = lib.mkEnableOption "room server";
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
      room.server-mini = {
        enable = mkDefault true;
        inherit (cfg) qemu-guest cloud-init;
      };
    };
  };
}
