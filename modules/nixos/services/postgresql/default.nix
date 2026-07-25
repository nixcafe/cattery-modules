{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    mkForce
    optionalAttrs
    ;

  cfg = config.${namespace}.services.postgresql;
in
{
  options.${namespace}.services.postgresql = with types; {
    enable = lib.mkEnableOption "postgresql";
    package = mkOption {
      type = nullOr package;
      default = null;
      description = ''
        The PostgreSQL package to use. Defaults to the system-wide PostgreSQL package
        when set to null.
      '';
    };
    openFirewall = lib.mkEnableOption "postgresql open firewall";
    configFile = {
      settingsPath = mkOption {
        type = path;
        default = "/etc/postgresql/postgresql.conf";
        description = ''
          except for options defined here: 
          <https://search.nixos.org/options?query=services.postgresql.settings>

          which cannot be overwritten, all others are subject to the file.

          options that cannot be overwritten have been moved to `${namespace}.services.postgresql.settings`.
        '';
      };
      identMapPath = mkOption {
        type = path;
        default = "/etc/postgresql/pg_ident.conf";
        description = ''
          Path to the PostgreSQL ident map configuration file.
        '';
      };
      authenticationPath = mkOption {
        type = path;
        default = "/etc/postgresql/pg_hba.conf";
        description = ''
          Path to the PostgreSQL host-based authentication (pg_hba) configuration file.
        '';
      };
    };
    settings = {
      shared_preload_libraries = mkOption {
        type = nullOr (coercedTo (listOf str) (concatStringsSep ", ") str);
        default = null;
        example = literalExpression ''[ "auto_explain" "anon" ]'';
        description = "List of libraries to be preloaded. ";
      };
      log_line_prefix = mkOption {
        type = str;
        default = "%q%r ";
        example = "%q[%r]%u@%d%a ";
        description = "Ref: <https://www.postgresql.org/docs/current/runtime-config-logging.html#GUC-LOG-LINE-PREFIX>.";
      };
      port = mkOption {
        type = port;
        default = 5432;
        description = ''
          Port on which PostgreSQL listens for connections.
        '';
      };
      jit = mkOption {
        type = enum [
          "on"
          "off"
        ];
        default = "off";
        description = ''
          Whether to enable JIT compilation for PostgreSQL.
        '';
      };
    };
    extraOptions = mkOption {
      type = attrs;
      default = { };
      description = ''
        Extra options merged into the PostgreSQL service configuration.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.settings.port ];
    };
    # postgresql
    services.postgresql = {
      enable = true;
      # https://www.postgresql.org/docs/current/pgupgrade.html
      settings = mkForce (
        {
          hba_file = cfg.configFile.authenticationPath;
          ident_file = cfg.configFile.identMapPath;
          include_if_exists = cfg.configFile.settingsPath;
        }
        // cfg.settings
      );
    }
    // (optionalAttrs (cfg.package != null) {
      inherit (cfg) package;
    })
    // cfg.extraOptions;
  };
}
