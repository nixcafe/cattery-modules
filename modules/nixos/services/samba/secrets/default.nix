{
  config,
  lib,
  namespace,
  purr ? { },
  ...
}:
let
  host = purr.meta.host or "localhost";
  inherit (lib) optional;
  inherit (lib.${namespace}.secrets) mkAppSecretsOption;
  inherit (config.${namespace}.secrets) files;

  cfgParent = config.${namespace}.services.samba;
  cfg = cfgParent.secrets;
in
{
  options.${namespace}.services.samba.secrets = mkAppSecretsOption {
    enable = cfgParent.enable && config.${namespace}.secrets.enable;
    appName = "samba";
    dirPath = "samba";
    fixedConfig = optional cfgParent.useWizard {
      name = "smbConf";
      fileName = "smb.conf";
    };
    scope = "hosts-global";
    currentInfo = {
      inherit host;
      user = config.${namespace}.user.name;
    };
    buildTargetPath = name: files.${name}.path;
    owner = "root";
    mode = "0440";
  };

  config = lib.mkIf cfg.enable {
    ${namespace}.secrets = cfg.secretMappingFiles;
    environment.etc = lib.mkIf cfg.etc.enable (lib.mapAttrs (_: lib.mkForce) cfg.etc.files);
  };
}
