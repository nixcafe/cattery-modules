{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.tool.antigravity-cli;
in
{
  options.${namespace}.cli-apps.tool.antigravity-cli = {
    enable = lib.mkEnableOption "antigravity-cli";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      antigravity-cli
    ];

    # All CLI state lives under ~/.gemini:
    #   antigravity-cli/{settings.json,keybindings.json,conversations,brain,history.jsonl,...}
    #   config/{projects,mcp_config.json,config.json}
    #   GEMINI.md, skills/
    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      directories = [
        ".gemini"
      ];
    };
  };
}
