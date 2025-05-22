{
  config,
  lib,
  namespace,
  host,
  ...
}:
let
  inherit (lib) mkAfter;
  inherit (lib.${namespace}.secrets) mkAppSecretsOption;
  inherit (config.${namespace}.secrets) files;

  cfgParent = config.${namespace}.nix;
  cfg = cfgParent.secrets;

  # Can store encrypted tokens.
in
{
  options.${namespace}.nix.secrets = mkAppSecretsOption {
    enable = false;
    appName = "nix";
    dirPath = "nix";
    fixedConfig = [
      {
        name = "encryptedPath";
        fileName = "encrypted.conf";
      }
    ];
    scope = "hosts-global";
    currentInfo = {
      inherit host;
      user = config.${namespace}.user.name;
    };
    buildTargetPath = name: files.${name}.path;
    owner = "root";
    # Read-only
    mode = "0440";
  };

  config = lib.mkIf cfg.enable {
    # secrets
    ${namespace}.secrets = cfg.secretMappingFiles;
    # etc configuration default path: `/etc/nix`
    environment.etc = lib.mkIf cfg.etc.enable cfg.etc.files;

    nix.extraOptions = mkAfter ''
      !include ${
        if cfg.etc.enable then "/etc/${cfg.files.encryptedPath.source}" else cfg.files.encryptedPath.target
      }
    '';
  };
}
