{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;
  inherit (config.${namespace}.user) settings;

  cfg = config.${namespace}.apps.vscode;
in
{
  options.${namespace}.apps.vscode = with types; {
    enable = lib.mkEnableOption "vscode";
    profiles = mkOption {
      type = attrs;
      default = settings.vscode.profiles or { };
    };
    commandLineArgs = mkOption {
      default = [ ];
      type = listOf str;
    };
    defaultEditor = lib.mkEnableOption "vscode to $EDITOR";
    extraOptions = mkOption {
      type = attrs;
      default = { };
    };
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.vscode = {
      inherit (cfg) enable profiles;
      package = pkgs.vscode.override {
        commandLineArgs = [
          "--enable-wayland-ime"
          "--ozone-platform=wayland"
        ] ++ cfg.commandLineArgs;
      };
    } // cfg.extraOptions;

    home.sessionVariables = lib.mkIf cfg.defaultEditor {
      EDITOR = "code --new-window --wait";
      VISUAL = "$EDITOR";
    };

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      directories = [
        ".vscode"
      ];
      xdg.config.directories = [
        "Code"
      ];
    };
  };

}
