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

  cfgParent = config.${namespace}.services.beszel;
  cfg = cfgParent.secrets;
in
{
  options.${namespace}.services.beszel.secrets = mkAppSecretsOption {
    enable = cfgParent.enable && cfgParent.agent.enable && config.${namespace}.secrets.enable;
    appName = "beszel";
    dirPath = "beszel/env";
    fixedConfig = [
      {
        name = "agentKey";
        fileName = "agent.env";
      }
    ];
    scope = "hosts-global";
    currentInfo = {
      inherit host;
      user = config.${namespace}.user.name;
    };
    buildTargetPath = name: files.${name}.path;
    owner = "root";
    mode = "0400";
  };

  config = lib.mkIf cfg.enable {
    ${namespace}.secrets = cfg.secretMappingFiles;
    environment.etc = lib.mkIf cfg.etc.enable cfg.etc.files;
  };
}
