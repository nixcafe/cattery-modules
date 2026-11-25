{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.tool.cursor-cli;
in
{
  options.${namespace}.cli-apps.tool.cursor-cli = {
    enable = lib.mkEnableOption "cursor-cli";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      cursor-cli
    ];

    # Cursor CLI uses ~/.cursor for MCP config and worktrees, and shares
    # ~/.config/Cursor with the Cursor editor.
    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      directories = [
        ".cursor"
      ];
      xdg.config.directories = [
        "Cursor"
      ];
    };
  };
}
