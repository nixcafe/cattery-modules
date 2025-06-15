{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.tool.claude-code;
in
{
  options.${namespace}.cli-apps.tool.claude-code = {
    enable = lib.mkEnableOption "claude-code";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      claude-code
    ];

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      directories = [
        ".claude"
      ];
    };
  };

}
