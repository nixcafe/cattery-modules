{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.tool.opencode;
in
{
  options.${namespace}.cli-apps.tool.opencode = {
    enable = lib.mkEnableOption "opencode";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.opencode = {
      enable = true;
      web.enable = true;
    };

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      xdg.data.directories = [
        "opencode"
      ];
    };
  };

}
