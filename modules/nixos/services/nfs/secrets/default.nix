{
  config,
  lib,
  namespace,
  purr ? { },
  ...
}:
let
  host = purr.meta.host or "localhost";
  inherit (lib) optional mkForce;
  inherit (lib.${namespace}.secrets) mkAppSecretsOption;
  inherit (config.${namespace}.secrets) files;

  cfgParent = config.${namespace}.services.nfs;
  cfg = cfgParent.secrets;
in
{
  options.${namespace}.services.nfs.secrets = mkAppSecretsOption {
    enable = cfgParent.enable && config.${namespace}.secrets.enable;
    appName = "nfs";
    dirPath = "nfs";
    fixedConfig = optional cfgParent.useWizard {
      name = "exports";
      fileName = "exports";
    };
    scope = "hosts-global";
    currentInfo = {
      inherit host;
      user = config.${namespace}.user.name;
    };
    buildTargetPath = name: files.${name}.path;
    owner = "root";
    mode = "0644";
  };

  config = lib.mkIf (cfg.enable && cfgParent.useWizard) {
    ${namespace}.secrets = cfg.secretMappingFiles;
    environment.etc = lib.mkIf cfg.etc.enable {
      exports = mkForce cfg.etc.files."nfs/exports";
    };
  };
}
