{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.apps.antigravity-ide;
in
{
  options.${namespace}.apps.antigravity-ide = {
    enable = lib.mkEnableOption "antigravity-ide";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      antigravity-ide
    ];

    # Electron userData: ~/.config/Antigravity IDE
    # VS Code-style data folder (extensions): ~/.antigravity-ide
    # Agent data: ~/.gemini/antigravity-ide
    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      directories = [
        ".gemini"
        ".antigravity-ide"
      ];
      xdg.config.directories = [
        "Antigravity IDE"
      ];
    };
  };
}
