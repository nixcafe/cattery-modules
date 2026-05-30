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

  cfgParent = config.${namespace}.cli-apps.dev-kit.git;
  cfg = cfgParent.secrets;
in
{
  options.${namespace}.cli-apps.dev-kit.git.secrets = mkHomeAppSecretsOption {
    enable = cfgParent.enable && config.${namespace}.secrets.enable;
    appName = "git";
    dirPath = "git";
    configNames = builtins.map (x: if builtins.isString x then x else x.name) cfgParent.includeNames;
    scope = "shared-user";
    currentInfo = {
      inherit host;
      user = config.${namespace}.user.name;
    };
    buildTargetPath = name: files.${name}.path;
    mode = "0444";
  };

  config = lib.mkIf cfg.enable {
    ${namespace}.secrets = cfg.secretMappingFiles;
  };
}
