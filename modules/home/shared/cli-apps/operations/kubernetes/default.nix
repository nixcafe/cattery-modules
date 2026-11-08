{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.operations.kubernetes;
in
{
  options.${namespace}.cli-apps.operations.kubernetes = {
    enable = lib.mkEnableOption "kubernetes";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # k8s
      kubectl
      kubernetes-helm
      argocd # just to help with configs at work
      k9s
      kubectx
      kustomize
      kubeseal
      stern
    ];

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      directories = [
        ".kube"
      ];
      xdg = {
        config.directories = [
          "argocd"
          "helm"
          "k9s"
        ];
        cache.directories = [
          "helm"
          "k9s"
        ];
        data.directories = [
          "helm"
          "k9s"
        ];
      };
    };
  };

}
