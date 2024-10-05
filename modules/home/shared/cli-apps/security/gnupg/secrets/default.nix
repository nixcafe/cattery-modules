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

  cfgParent = config.${namespace}.cli-apps.security.gnupg;
  cfg = cfgParent.secrets;
in
{
  options.${namespace}.cli-apps.security.gnupg.secrets = mkHomeAppSecretsOption {
    enable = cfgParent.enable && config.${namespace}.secrets.enable;
    appName = "gnupg";
    dirPath = "gnupg";
    scope = "shared-user";
    currentInfo = {
      inherit host;
      user = config.${namespace}.user.name;
    };
    buildTargetPath = name: files.${name}.path;
    # ban
    mode = "0000";
  };

  config = lib.mkIf cfg.enable {
    # secrets
    ${namespace}.secrets = cfg.secretMappingFiles;
  };
}
