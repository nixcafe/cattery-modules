{
  config,
  lib,
  namespace,
  purr ? { },
  ...
}:
let
  host = purr.host or purr.name or "localhost";
  inherit (lib) optional;
  inherit (lib.${namespace}.secrets) mkAppSecretsOption;
  inherit (config.${namespace}.secrets) files;

  cfgParent = config.${namespace}.services.sanoid;
  cfg = cfgParent.secrets;
in
{
  options.${namespace}.services.sanoid.secrets = mkAppSecretsOption {
    enable = cfgParent.enable && config.${namespace}.secrets.enable;
    appName = "sanoid";
    dirPath = "sanoid";
    fixedConfig = optional cfgParent.useWizard {
      name = "sanoidConf";
      fileName = "sanoid.conf";
    };
    scope = "hosts-global";
    currentInfo = {
      inherit host;
      user = config.${namespace}.user.name;
    };
    buildTargetPath = name: files.${name}.path;
    owner = "root";
    mode = "0444";
  };

  config = lib.mkIf cfg.enable {
    ${namespace}.secrets = cfg.secretMappingFiles;
    environment.etc = lib.mkIf cfg.etc.enable (lib.mapAttrs (_: lib.mkForce) cfg.etc.files);
  };
}
