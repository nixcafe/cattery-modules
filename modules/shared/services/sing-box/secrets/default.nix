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

  cfgParent = config.${namespace}.services.sing-box;
  cfg = cfgParent.secrets;
in
{
  options.${namespace}.services.sing-box.secrets = mkAppSecretsOption {
    enable = cfgParent.enable && config.${namespace}.secrets.enable;
    appName = "sing-box";
    dirPath = "sing-box";
    fixedConfig = [
      {
        name = "settingsPath";
        fileName = "config.json";
      }
    ];
    scope = "shared-global";
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
    # etc configuration default path: `/etc/sing-box`
    environment.etc = lib.mkIf cfg.etc.enable cfg.etc.files;
  };
}
