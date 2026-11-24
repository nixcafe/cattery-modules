{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.apps.antigravity-hub;
in
{
  options.${namespace}.apps.antigravity-hub = {
    enable = lib.mkEnableOption "antigravity-hub";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      antigravity-hub
    ];

    # Electron userData: ~/.config/Antigravity
    #   app_storage.json, window_state.json, logs, WSL state
    # Agent data: ~/.gemini/antigravity
    # Shared settings: ~/.gemini/config/config.json
    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      directories = [
        ".gemini"
      ];
      xdg.config.directories = [
        "Antigravity"
      ];
    };
  };
}
