{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.services.netdata;
in
{
  options.${namespace}.services.netdata = with types; {
    enable = lib.mkEnableOption "netdata monitoring";
    config = mkOption {
      type = attrs;
      default = { };
      description = "Netdata configuration merged at services.netdata.config.";
    };
    extraOptions = mkOption {
      type = attrs;
      default = { };
      description = "Extra services.netdata NixOS options merged at top level.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.netdata = {
      enable = true;
      inherit (cfg) config;
    }
    // cfg.extraOptions;
  };
}
