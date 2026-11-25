{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.tool.qwen-code;
in
{
  options.${namespace}.cli-apps.tool.qwen-code = {
    enable = lib.mkEnableOption "qwen-code";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      qwen-code
    ];

    # Qwen Code keeps global settings, projects, memories, and hooks in ~/.qwen.
    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      directories = [
        ".qwen"
      ];
    };
  };
}
