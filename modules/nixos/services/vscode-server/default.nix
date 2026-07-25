{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.services.vscode-server;
in
{
  options.${namespace}.services.vscode-server = with types; {
    enable = lib.mkEnableOption "vscode server";
    extraOptions = mkOption {
      type = attrs;
      default = { };
      description = "Extra services.vscode-server NixOS options merged at top level.";
    };
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    services.vscode-server = {
      enable = true;
    }
    // cfg.extraOptions;

    ${namespace}.home.extraOptions = {
      ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
        directories = [
          ".vscode-server"
        ];
      };
    };
  };

}
