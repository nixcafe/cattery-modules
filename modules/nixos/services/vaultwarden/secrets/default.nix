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

  cfgParent = config.${namespace}.services.vaultwarden;
  cfg = cfgParent.secrets;
in
{
  options.${namespace}.services.vaultwarden.secrets = mkAppSecretsOption {
    enable = cfgParent.enable && config.${namespace}.secrets.enable;
    appName = "vaultwarden";
    dirPath = "vaultwarden";
    fixedConfig = [
      {
        name = "settingsPath";
        fileName = "vaultwarden.env";
      }
    ];
    scope = "hosts-global";
    currentInfo = {
      inherit host;
      user = config.${namespace}.user.name;
    };
    buildTargetPath = name: files.${name}.path;
    owner = "vaultwarden";
    # Read-only
    mode = "0400";
  };

  config = lib.mkIf cfg.enable {
    # secrets
    ${namespace}.secrets = cfg.secretMappingFiles;
    # etc configuration default path: `/etc/vaultwarden`
    environment.etc = lib.mkIf cfg.etc.enable cfg.etc.files;
  };
}
