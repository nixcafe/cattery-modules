{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.tool.goose;
in
{
  options.${namespace}.cli-apps.tool.goose = {
    enable = lib.mkEnableOption "goose";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      goose-cli
    ];

    # Goose keeps config/secrets under ~/.config/goose and the session SQLite
    # database under ~/.local/share/goose.
    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      xdg.config.directories = [
        "goose"
      ];
      xdg.data.directories = [
        "goose"
      ];
    };
  };
}
