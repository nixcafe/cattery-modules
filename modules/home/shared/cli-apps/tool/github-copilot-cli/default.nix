{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.tool.github-copilot-cli;
in
{
  options.${namespace}.cli-apps.tool.github-copilot-cli = {
    enable = lib.mkEnableOption "github-copilot-cli";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      github-copilot-cli
    ];

    # CLI config, logs, and MCP config live under ~/.copilot.
    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      directories = [
        ".copilot"
      ];
    };
  };
}
