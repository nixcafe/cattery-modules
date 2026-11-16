{
  config,
  lib,
  namespace,
  purr ? { },
  ...
}:
let
  host = purr.meta.host or "localhost";
  inherit (lib) mapAttrsToList;
  inherit (lib.${namespace}.secrets) mkAppSecretsOption;
  inherit (config.${namespace}.secrets) files;

  cfgParent = config.${namespace}.services.forgejo-runner;
  cfg = cfgParent.secrets;
in
{
  options.${namespace}.services.forgejo-runner.secrets = mkAppSecretsOption {
    enable = cfgParent.enable && config.${namespace}.secrets.enable;
    appName = "forgejo runner";
    dirPath = "forgejo-runner";
    scope = "hosts-global";
    configNames = mapAttrsToList (name: _: "${name}.token") cfgParent.instances;
    currentInfo = {
      inherit host;
      user = config.${namespace}.user.name;
    };
    buildTargetPath = name: files.${name}.path;
    # The runner reads the token through systemd `LoadCredential=` (as root),
    # so the decrypted file only needs to be root-readable.
    owner = "root";
    mode = "0400";
  };

  config = lib.mkIf cfg.enable {
    # Register the age secret and expose it as a stable `/etc` path, matching
    # the other cattery app secrets:
    #   /etc/forgejo-runner/<instance>.token
    ${namespace}.secrets = cfg.secretMappingFiles;
    environment.etc = lib.mkIf cfg.etc.enable cfg.etc.files;
  };
}
