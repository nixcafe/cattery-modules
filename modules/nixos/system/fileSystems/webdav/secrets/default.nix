{
  config,
  lib,
  namespace,
  purr ? { },
  ...
}:
let
  host = purr.meta.host or "localhost";
  inherit (lib.${namespace}.secrets) mkAppSecretsOption;
  inherit (config.${namespace}.secrets) files;

  cfgParent = config.${namespace}.system.fileSystems.webdav;
  cfg = cfgParent.secrets;
in
{
  options.${namespace}.system.fileSystems.webdav.secrets = mkAppSecretsOption {
    enable = cfgParent.enable && config.${namespace}.secrets.enable;
    appName = "webdav";
    dirPath = "davfs2";
    configNames = [ "secrets" ];
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
    # bind to `/etc/davfs2/secrets`
    environment.etc = lib.mkIf cfg.etc.enable cfg.etc.files;
  };
}
