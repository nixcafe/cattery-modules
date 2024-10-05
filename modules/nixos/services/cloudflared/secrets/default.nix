{
  config,
  lib,
  namespace,
  host,
  ...
}:
let
  inherit (lib) foldl';
  inherit (lib.${namespace}.secrets) mkAppSecretsOption;
  inherit (config.${namespace}.secrets) files;

  cfgParent = config.${namespace}.services.cloudflared;
  cfg = cfgParent.secrets;
in
{
  options.${namespace}.services.cloudflared.secrets = mkAppSecretsOption {
    enable = cfgParent.enable && config.${namespace}.secrets.enable;
    appName = "cloudflared";
    dirPath = "cloudflared/credentials";
    configNames =
      let
        names = builtins.attrNames cfgParent.tunnels;
      in
      foldl' (
        acc: name:
        acc
        ++ [
          "${name}.json"
        ]
      ) [ ] names;
    scope = "shared-global";
    currentInfo = {
      inherit host;
      user = config.${namespace}.user.name;
    };
    buildTargetPath = name: files.${name}.path;
    owner = "cloudflared";
    # Read-only
    mode = "0400";
  };

  config = lib.mkIf cfg.enable {
    # secrets
    ${namespace}.secrets = cfg.secretMappingFiles;
    # etc configuration default path: `/etc/cloudflared/credentials`
    environment.etc = lib.mkIf cfg.etc.enable cfg.etc.files;
  };
}
