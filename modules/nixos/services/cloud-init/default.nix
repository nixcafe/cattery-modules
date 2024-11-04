{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.services.cloud-init;
in
{
  options.${namespace}.services.cloud-init = with types; {
    enable = lib.mkEnableOption "cloud init";
    network.enable = lib.mkEnableOption "cloud network init";
    extraOptions = mkOption {
      type = attrs;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    services.cloud-init = {
      enable = true;
      network.enable = cfg.network.enable;
    } // cfg.extraOptions;
  };
}
