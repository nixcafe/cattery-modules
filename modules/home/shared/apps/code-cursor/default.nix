{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.apps.code-cursor;
in
{
  options.${namespace}.apps.code-cursor = {
    enable = lib.mkEnableOption "code-cursor";
    defaultEditor = lib.mkEnableOption "code-cursor to $EDITOR";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        code-cursor
      ];

      sessionVariables = lib.mkIf cfg.defaultEditor {
        EDITOR = "cursor --new-window --wait";
        VISUAL = "$EDITOR";
      };
    };

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
