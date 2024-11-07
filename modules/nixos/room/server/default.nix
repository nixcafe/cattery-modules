{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkDefaultEnabled;

  cfg = config.${namespace}.room.server;
in
{
  options.${namespace}.room.server = {
    enable = lib.mkEnableOption "room server";
    cloud-init = {
      enable = lib.mkEnableOption "cloud init";
      network.enable = lib.mkEnableOption "cloud network init";
    };
  };

  config = lib.mkIf cfg.enable {
    ${namespace} = {
      room.general = mkDefaultEnabled;

      services = {
        inherit (cfg) cloud-init;
        acme = mkDefaultEnabled;
      };
    };
  };
}
