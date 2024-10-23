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

  cfgParent = config.${namespace}.services.forgejo;
  cfg = cfgParent.secrets;
in
{
  options.${namespace}.services.forgejo.secrets = mkAppSecretsOption {
    enable = cfgParent.enable && config.${namespace}.secrets.enable;
    appName = "forgejo";
    dirPath = "forgejo/conf";
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
    owner = "forgejo";
    # Read-only
    mode = "0400";
  };

  config = lib.mkIf cfg.enable {
    # secrets
    ${namespace}.secrets = cfg.secretMappingFiles;
    # etc configuration default path: `/etc/forgejo/conf`
    environment.etc = lib.mkIf cfg.etc.enable cfg.etc.files;
  };
}
