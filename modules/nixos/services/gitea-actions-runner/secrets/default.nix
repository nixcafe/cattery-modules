{
  config,
  lib,
  namespace,
  host,
  ...
}:
let
  inherit (lib) mapAttrsToList;
  inherit (lib.${namespace}.secrets) mkAppSecretsOption;
  inherit (config.${namespace}.secrets) files;

  cfgParent = config.${namespace}.services.gitea-actions-runner;
  cfg = cfgParent.secrets;
in
{
  options.${namespace}.services.gitea-actions-runner.secrets = mkAppSecretsOption {
    enable = cfgParent.enable && config.${namespace}.secrets.enable;
    appName = "gitea actions runner";
    dirPath = "gitea-runner/env";
    scope = "hosts-global";
    configNames = mapAttrsToList (_: value: "${value.name}.env") cfgParent.instances;
    currentInfo = {
      inherit host;
      user = config.${namespace}.user.name;
    };
    buildTargetPath = name: files.${name}.path;
    owner = "gitea-runner";
    # Read-only
    mode = "0400";
  };

  config = lib.mkIf cfg.enable {
    # secrets
    ${namespace}.secrets = cfg.secretMappingFiles;
    # etc configuration default path: `/etc/gitea-runner/env`
    environment.etc = lib.mkIf cfg.etc.enable cfg.etc.files;
  };
}
