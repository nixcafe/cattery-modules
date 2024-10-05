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

  cfgParent = config.${namespace}.services.nginx;
  cfg = cfgParent.secrets;
in
{
  options.${namespace}.services.nginx.secrets = mkAppSecretsOption {
    enable = cfgParent.enable && config.${namespace}.secrets.enable;
    appName = "nginx";
    dirPath = "nginx/conf.d";
    scope = "hosts-global";
    currentInfo = {
      inherit host;
      user = config.${namespace}.user.name;
    };
    buildTargetPath = name: files.${name}.path;
    owner = "nginx";
    # Read-only
    mode = "0440";
  };

  config = lib.mkIf cfg.enable {
    # secrets
    ${namespace}.secrets = cfg.secretMappingFiles;
    # etc configuration default path: `/etc/nginx/conf.d`
    environment.etc = lib.mkIf cfg.etc.enable cfg.etc.files;
  };
}
