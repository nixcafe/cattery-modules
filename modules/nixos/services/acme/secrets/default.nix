{
  config,
  lib,
  namespace,
  host,
  ...
}:
let
  inherit (lib) optionalString unique foldl';
  inherit (lib.${namespace}) getRootDomain;
  inherit (lib.${namespace}.secrets) mkAppSecretsOption;
  inherit (config.${namespace}.secrets) files;

  cfgParent = config.${namespace}.services.acme;
  cfg = cfgParent.secrets;
in
{
  options.${namespace}.services.acme.secrets = mkAppSecretsOption {
    enable = cfgParent.enable && config.${namespace}.secrets.enable;
    appName = "acme";
    dirPath = "acme/env";
    configNames =
      let
        names = builtins.attrNames cfgParent.certs;
      in
      unique (
        foldl' (
          acc: name:
          acc
          ++ [
            "${
              optionalString ((cfgParent.certs.${name}.environmentFile or null) == null) (getRootDomain name)
            }.env"
          ]
        ) [ ] names
      );
    scope = "shared-global";
    currentInfo = {
      inherit host;
      user = config.${namespace}.user.name;
    };
    buildTargetPath = name: files.${name}.path;
    owner = "acme";
    # Read-only
    mode = "0400";
  };

  config = lib.mkIf cfg.enable {
    # secrets
    ${namespace}.secrets = cfg.secretMappingFiles;
    # etc configuration default path: `/etc/acme/env`
    environment.etc = lib.mkIf cfg.etc.enable cfg.etc.files;
  };
}
