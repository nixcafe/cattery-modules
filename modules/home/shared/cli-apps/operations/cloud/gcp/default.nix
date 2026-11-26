{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.operations.cloud.gcp;
in
{
  options.${namespace}.cli-apps.operations.cloud.gcp = {
    enable = lib.mkEnableOption "gcp";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      google-cloud-sdk
    ];

    # gcloud, gsutil, and bq configuration and credentials.
    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      xdg.config.directories = [
        "gcloud"
      ];
    };
  };
}
