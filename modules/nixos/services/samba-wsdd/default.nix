{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.services.samba-wsdd;
in
{
  options.${namespace}.services.samba-wsdd = with types; {
    enable = lib.mkEnableOption "samba wsdd";
    openFirewall = mkOption {
      type = bool;
      default = false;
      description = "Open WSDD ports (TCP 5357, UDP 3702) in the firewall for Windows network discovery.";
    };
    extraOptions = mkOption {
      type = attrs;
      default = { };
      description = "Extra services.samba-wsdd NixOS options merged at top level.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.samba-wsdd = {
      enable = true;
      inherit (cfg) openFirewall;
    }
    // cfg.extraOptions;
  };
}
