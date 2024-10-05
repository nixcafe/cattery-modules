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

  cfgParent = config.${namespace}.system.fileSystems.samba;
  cfg = cfgParent.secrets;
in
{
  options.${namespace}.system.fileSystems.samba.secrets = mkAppSecretsOption {
    enable = cfgParent.enable && config.${namespace}.secrets.enable;
    appName = "samba";
    dirPath = "samba/secrets";
    configNames = map (name: "${name}.conf") (builtins.attrNames cfgParent.client);
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
    # etc configuration default path: `/etc/samba/secrets`
    environment.etc = lib.mkIf cfg.etc.enable cfg.etc.files;
  };
}
