{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.operations.cloud.vultr;
in
{
  options.${namespace}.cli-apps.operations.cloud.vultr = {
    enable = lib.mkEnableOption "vultr";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      vultr-cli
    ];

    # vultr-cli defaults to ~/.vultr-cli.yaml. It prefers
    # ~/.config/vultr-cli.yaml only when that file already exists.
    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      files = [
        ".vultr-cli.yaml"
      ];
    };
  };
}
