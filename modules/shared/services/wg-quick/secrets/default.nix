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

  cfgParent = config.${namespace}.services.wg-quick;
  cfg = cfgParent.secrets;
in
{
  options.${namespace}.services.wg-quick.secrets = mkAppSecretsOption {
    enable = cfgParent.enable && config.${namespace}.secrets.enable;
    appName = "wg-quick";
    dirPath = "wireguard";
    configNames = map (name: "${name}.conf") cfgParent.configNames;
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
    # etc configuration default path: `/etc/wireguard`
    environment.etc = lib.mkIf cfg.etc.enable cfg.etc.files;
  };
}
