{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.services.avahi;
in
{
  options.${namespace}.services.avahi = with types; {
    enable = lib.mkEnableOption "avahi mDNS";
    openFirewall = mkOption {
      type = bool;
      default = false;
      description = "Open Avahi mDNS port (UDP 5353) in the firewall.";
    };
    publish = {
      enable = mkOption {
        type = bool;
        default = true;
        description = "Whether to publish local services via Avahi.";
      };
    };
    extraOptions = mkOption {
      type = attrs;
      default = { };
      description = "Extra services.avahi NixOS options merged at top level.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.avahi = {
      enable = true;
      inherit (cfg) openFirewall publish;
    }
    // cfg.extraOptions;
  };
}
