{
  config,
  lib,
  namespace,
  host,
  ...
}:
let
  inherit (lib.${namespace}.secrets) mkAppSecretsOption;
  inherit (config.${namespace}.secrets) files;

  cfgParent = config.${namespace}.services.postgresql;
  cfg = cfgParent.secrets;
in
{
  options.${namespace}.services.postgresql.secrets = mkAppSecretsOption {
    enable = cfgParent.enable && config.${namespace}.secrets.enable;
    appName = "postgresql";
    dirPath = "postgresql";
    fixedConfig = [
      {
        name = "settingsPath";
        fileName = "postgresql.conf";
      }
      {
        name = "identMapPath";
        fileName = "pg_ident.conf";
      }
      {
        name = "authenticationPath";
        fileName = "pg_hba.conf";
      }
    ];
    scope = "hosts-global";
    currentInfo = {
      inherit host;
      user = config.${namespace}.user.name;
    };
    buildTargetPath = name: files.${name}.path;
    owner = "postgres";
    # Read-only
    mode = "0400";
  };

  config = lib.mkIf cfg.enable {
    # secrets
    ${namespace}.secrets = cfg.secretMappingFiles;
    # etc configuration default path: `/etc/postgresql`
    environment.etc = lib.mkIf cfg.etc.enable cfg.etc.files;
  };
}
