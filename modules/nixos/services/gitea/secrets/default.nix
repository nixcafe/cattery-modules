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

  cfgParent = config.${namespace}.services.gitea;
  cfg = cfgParent.secrets;
in
{
  options.${namespace}.services.gitea.secrets = mkAppSecretsOption {
    enable = cfgParent.enable && config.${namespace}.secrets.enable;
    appName = "gitea";
    dirPath = "gitea/conf";
    fixedConfig = [
      {
        name = "settingsPath";
        fileName = "app.ini";
      }
    ];
    scope = "hosts-global";
    currentInfo = {
      inherit host;
      user = config.${namespace}.user.name;
    };
    buildTargetPath = name: files.${name}.path;
    owner = "gitea";
    # Read-only
    mode = "0400";
  };

  config = lib.mkIf cfg.enable {
    # secrets
    ${namespace}.secrets = cfg.secretMappingFiles;
    # etc configuration default path: `/etc/gitea/conf`
    environment.etc = lib.mkIf cfg.etc.enable cfg.etc.files;
  };
}
