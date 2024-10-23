{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types mkBefore;

  cfg = config.${namespace}.services.forgejo;
in
{
  options.${namespace}.services.forgejo = with types; {
    enable = lib.mkEnableOption "forgejo";
    dbBackend = mkOption {
      type = enum [
        "sqlite"
        "mysql"
        "postgresql"
      ];
      default = "sqlite";
      description = "To run forgejo after database service.";
    };
    useWizard = lib.mkEnableOption "forgejo use host config";
    configFile = {
      settingsPath = mkOption {
        type = path;
        default = "/etc/forgejo/conf/app.ini";
        description = ''
          If useWizard is enabled, the config files 
          will be copied to ${config.services.forgejo.customDir}.
          config manual ref: <https://forgejo.org/docs/latest/admin/config-cheat-sheet>
        '';
      };
    };
    settings = mkOption {
      type = attrs;
      default = { };
    };
    extraOptions = mkOption {
      type = attrs;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    services.forgejo = {
      inherit (cfg) enable useWizard settings;
      database.type =
        if cfg.dbBackend == "sqlite" then
          "sqlite3"
        else
          (if cfg.dbBackend == "postgresql" then "postgres" else cfg.dbBackend);
    } // cfg.extraOptions;

    systemd.services.forgejo = lib.mkIf cfg.useWizard (
      let
        configFile = "${cfg.configFile.settingsPath}";
        runConfig = "${config.services.forgejo.customDir}/conf/app.ini";
        pathConfig = "${config.services.forgejo.customDir}/conf/rootPath";
        staticRootPath = config.services.forgejo.settings.server.STATIC_ROOT_PATH;
        replaceSecretBin = "${pkgs.replace-secret}/bin/replace-secret";
      in
      {
        preStart = mkBefore ''
          function forgejo_custom_config {
            if [ -s '${configFile}' ]; then
              cp -f '${configFile}' '${runConfig}'
              chmod u+w '${runConfig}'
              echo '${staticRootPath}' > '${pathConfig}'
              ${replaceSecretBin} '#staticRootPath#' '${pathConfig}' '${runConfig}'
              rm -f '${pathConfig}'
              chmod u-w '${runConfig}'
            fi
          }
          (umask 027; forgejo_custom_config)
        '';
      }
    );
  };
}
