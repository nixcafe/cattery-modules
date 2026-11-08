{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.operations.serverless;
in
{
  options.${namespace}.cli-apps.operations.serverless = {
    enable = lib.mkEnableOption "serverless and function command-line tools";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # OpenFaaS
      faas-cli
      # Knative / Knative Functions
      kn
      func
      # Fission
      fission
      # General workload scheduler
      nomad
    ];

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      # OpenFaaS CLI gateway credentials and plugins live here.
      directories = [
        ".openfaas"
      ];
    };
  };
}
