{
  config,
  lib,
  namespace,
  purr ? { },
  ...
}:
let
  host = purr.meta.host or "localhost";
  inherit (lib.${namespace}.secrets) mkAppSecretsOption;
  inherit (config.${namespace}.secrets) files;

  cfgParent = config.${namespace}.services.adguardhome;
  cfg = cfgParent.secrets;
in
{
  options.${namespace}.services.adguardhome.secrets = mkAppSecretsOption {
    enable = cfgParent.enable && config.${namespace}.secrets.enable;
    appName = "adguardhome";
    dirPath = "adguardhome";
    fixedConfig = [
      {
        name = "config";
        fileName = "AdGuardHome.yaml";
      }
    ];
    scope = "hosts-global";
    currentInfo = {
      inherit host;
      user = config.${namespace}.user.name;
    };
    buildTargetPath = name: files.${name}.path;
    owner = "root";
    # Read-only
    mode = "0400";
  };

  config = lib.mkIf cfg.enable {
    # secrets
    ${namespace}.secrets = cfg.secretMappingFiles;
    # bind to `/etc/adguardhome/AdGuardHome.yaml`
    environment.etc = lib.mkIf cfg.etc.enable cfg.etc.files;
  };
}
