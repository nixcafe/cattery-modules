{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.tool.misc;
in
{
  options.${namespace}.cli-apps.tool.misc = {
    enable = lib.mkEnableOption "misc";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      xdg.cache.directories = [
        "pre-commit"
      ];
    };
  };

}
