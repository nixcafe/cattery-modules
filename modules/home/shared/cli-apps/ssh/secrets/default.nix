{
  config,
  lib,
  namespace,
  host,
  ...
}:
let
  inherit (lib.${namespace}.secrets) mkHomeAppSecretsOption;
  inherit (config.${namespace}.secrets) files;

  cfgParent = config.${namespace}.cli-apps.ssh;
  cfg = cfgParent.secrets;
in
{
  options.${namespace}.cli-apps.ssh.secrets = mkHomeAppSecretsOption {
    enable = cfgParent.enable && config.${namespace}.secrets.enable;
    appName = "ssh";
    dirPath = "ssh";
    configNames = cfgParent.includeNames;
    scope = "shared-user";
    currentInfo = {
      inherit host;
      user = config.${namespace}.user.name;
    };
    buildTargetPath = name: files.${name}.path;
    # Read-only
    mode = "0444";
  };

  config = lib.mkIf cfg.enable {
    # secrets
    ${namespace}.secrets = cfg.secretMappingFiles;
  };
}
