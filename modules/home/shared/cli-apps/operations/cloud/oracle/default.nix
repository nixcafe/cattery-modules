{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.operations.cloud.oracle;
in
{
  options.${namespace}.cli-apps.operations.cloud.oracle = {
    enable = lib.mkEnableOption "oracle";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      oci-cli
    ];

    # OCI CLI config, API keys, and session data live under ~/.oci.
    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      directories = [
        ".oci"
      ];
    };
  };
}
