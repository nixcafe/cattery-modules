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
    dataDir = mkOption {
      type = nullOr path;
      default = null;
      example = "/data/postgresql";
      description = ''
        The data directory for PostgreSQL.  When left as `null`, uses the
        nixpkgs default (`/var/lib/postgresql/<version>`).  When set, the
        sysadmin is responsible for ensuring the directory exists with
        appropriate ownership (`postgres:postgres`) — `initdb` will set
        the correct permissions (0700) automatically.

        When `useWizard` is enabled, make sure your agenix `postgresql.conf`
        does **not** set `data_directory` — let PGDATA handle it.
      '';
    };
    openFirewall = lib.mkEnableOption "postgresql open firewall";
    enableTCPIP = lib.mkEnableOption "postgresql listen on all interfaces";
    useWizard = lib.mkEnableOption "postgresql use host config via agenix";
    configFile = {
      settingsPath = mkOption {
        type = path;
        default = "/etc/postgresql/postgresql.conf";
        description = ''
          When `useWizard` is enabled, this file (decrypted by agenix)
          is appended as an `include` at the end of `postgresql.conf`,
          giving it the final word on all settings — nixpkgs handles
          infrastructure (`hba_file`, `ident_file`, etc.) and the
          agenix file overrides runtime tuning.

          When `useWizard` is disabled, PostgreSQL uses the nixpkgs
          native configuration and this option has no effect.

          <https://www.postgresql.org/docs/current/runtime-config.html>
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
    ensureDatabases = mkOption {
      type = listOf str;
      default = [ ];
      example = [
        "hydra"
        "nextcloud"
      ];
      description = ''
        Ensures that the specified databases exist.
        This option will never delete existing databases.
      '';
    };
    ensureUsers = mkOption {
      type = listOf attrs;
      default = [ ];
      example = literalExpression ''
        [
          {
            name = "hydra";
            ensureDBOwnership = true;
          }
        ]
      '';
      description = ''
        Ensures that the specified users exist.
        Passed directly to {option}`services.postgresql.ensureUsers`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.settings.port ];
    };
    services.postgresql = {
      enable = true;
      inherit (cfg)
        ensureDatabases
        ensureUsers
        enableTCPIP
        ;
    }
    // optionalAttrs (cfg.dataDir != null) {
      inherit (cfg) dataDir;
    }
    // optionalAttrs (!cfg.useWizard) {
      inherit (cfg) settings;
    }
    // (optionalAttrs (cfg.package != null) {
      inherit (cfg) package;
    })
    // cfg.extraOptions;

    systemd.services.postgresql.preStart = lib.mkIf cfg.useWizard (
      lib.mkAfter ''
        p="${config.services.postgresql.dataDir}/postgresql.conf"
        cat "$p" > "$p.tmp"
        echo >> "$p.tmp"
        echo "include = '${cfg.configFile.settingsPath}'" >> "$p.tmp"
        mv "$p.tmp" "$p"
      ''
    );
  };
}
