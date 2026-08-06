{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.services.syncoid;
in
{
  options.${namespace}.services.syncoid = with types; {
    enable = lib.mkEnableOption "syncoid zfs replication";

    interval = mkOption {
      type = either str (listOf str);
      default = "hourly";
      example = "*-*-* *:15:00";
      description = ''
        Run syncoid at this interval (systemd.time format).
        The default is to run hourly.
        Set to an empty list to avoid starting syncoid automatically.
      '';
    };

    commands = mkOption {
      type = attrs;
      default = { };
      example = lib.literalExpression ''
        {
          "pool/test".target = "root@target:pool/test";
        }
      '';
      description = ''
        Syncoid replication commands (source to target dataset).
        See <option>services.syncoid.commands</option> for the full schema.
      '';
    };

    commonArgs = mkOption {
      type = listOf str;
      default = [ ];
      example = [ "--no-sync-snap" ];
      description = "Arguments added to every syncoid command.";
    };

    sshKey = mkOption {
      type = nullOr (coercedTo path toString str);
      default = null;
      description = "SSH private key file used to log in to remote systems.";
    };

    extraOptions = mkOption {
      type = attrs;
      default = { };
      description = "Extra services.syncoid NixOS options merged at top level.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.syncoid = {
      enable = true;
      inherit (cfg)
        interval
        commands
        commonArgs
        sshKey
        ;
    }
    // cfg.extraOptions;
  };
}
