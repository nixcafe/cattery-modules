{
  config,
  lib,
  namespace,
  purr ? { },
  ...
}:
let
  host = purr.host or purr.name or "localhost";
  inherit (lib.${namespace}.secrets) mkAppSecretsOption;
  inherit (config.${namespace}.secrets) files;

  cfgParent = config.${namespace}.cli-apps.ssh;
  cfg = cfgParent.secrets;
in
{
  options.${namespace}.cli-apps.ssh.secrets = mkAppSecretsOption {
    inherit (config.${namespace}.secrets) enable;
    appName = "ssh";
    dirPath = "ssh";
    configNames = cfgParent.knownHostsFileNames;
    scope = "shared-global";
    currentInfo = {
      inherit host;
      user = config.${namespace}.user.name;
    };
    buildTargetPath = name: files.${name}.path;
    owner = "root";
    # Read-only
    mode = "0444";
  };

  config = lib.mkIf cfg.enable {
    # secrets
    ${namespace}.secrets = cfg.secretMappingFiles;
    # etc configuration default path: `/etc/ssh`
    environment.etc = lib.mkIf cfg.etc.enable cfg.etc.files;
  };
}
