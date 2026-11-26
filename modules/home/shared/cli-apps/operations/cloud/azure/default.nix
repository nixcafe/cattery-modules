{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.operations.cloud.azure;
in
{
  options.${namespace}.cli-apps.operations.cloud.azure = {
    enable = lib.mkEnableOption "azure";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      azure-cli
    ];

    # Azure CLI profiles, tokens, and configuration.
    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      directories = [
        ".azure"
      ];
    };
  };
}
