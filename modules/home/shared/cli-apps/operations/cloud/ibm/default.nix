{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.operations.cloud.ibm;
in
{
  options.${namespace}.cli-apps.operations.cloud.ibm = {
    enable = lib.mkEnableOption "ibm";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      ibmcloud-cli
    ];

    # The IBM Cloud CLI stores session metadata in ~/.bluemix by default.
    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      directories = [
        ".bluemix"
      ];
    };
  };
}
