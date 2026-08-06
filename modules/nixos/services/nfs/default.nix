{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types optionalAttrs;

  cfg = config.${namespace}.services.nfs;
in
{
  options.${namespace}.services.nfs = with types; {
    enable = lib.mkEnableOption "nfs server";
    openFirewall = mkOption {
      type = bool;
      default = false;
      description = "Open NFS ports (TCP/UDP 2049, 111) in the firewall.";
    };
    useWizard = lib.mkEnableOption "nfs use host config";
    configFile = {
      settingsPath = mkOption {
        type = path;
        default = "/etc/exports";
        description = "Path to the NFS exports file.";
      };
    };
    exports = mkOption {
      type = attrs;
      default = { };
      example = lib.literalExpression ''
        {
          "/export" = {
            "192.168.1.0/24" = [
              "rw"
              "sync"
              "no_subtree_check"
            ];
          };
        }
      '';
      description = ''
        NFS exports merged at <option>services.nfs.server.exports</option>.
        See <option>services.nfs.server.exports</option> for the full format.
      '';
    };
    extraOptions = mkOption {
      type = attrs;
      default = { };
      description = "Extra services.nfs.server NixOS options merged at top level.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.nfs.server = {
      enable = true;
    }
    // optionalAttrs (!cfg.useWizard) {
      inherit (cfg) exports;
    }
    // cfg.extraOptions;

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [
        2049
        111
      ];
      allowedUDPPorts = [
        2049
        111
      ];
    };
  };
}
