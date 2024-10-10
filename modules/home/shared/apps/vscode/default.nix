{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.apps.vscode;
in
{
  options.${namespace}.apps.vscode = with types; {
    enable = lib.mkEnableOption "vscode";
    commandLineArgs = mkOption {
      default = [ ];
      type = listOf str;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscode.override {
        commandLineArgs = [
          "--enable-wayland-ime"
          "--ozone-platform=wayland"
        ] ++ cfg.commandLineArgs;
      };
    };
  };

}
