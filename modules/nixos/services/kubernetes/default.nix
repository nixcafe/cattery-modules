{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib)
    elem
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optionals
    types
    ;

  cfg = config.${namespace}.services.kubernetes;
in
{
  options.${namespace}.services.kubernetes = with types; {
    enable = mkEnableOption "upstream Kubernetes";
    package = mkPackageOption pkgs "kubernetes" { };
    roles = mkOption {
      type = listOf (enum [
        "master"
        "node"
      ]);
      default = [
        "master"
        "node"
      ];
      description = ''
        Kubernetes roles for this host. A single-node installation uses both
        `master` and `node`; a control-plane-only host can use `master`, and
        a worker can use `node`.
      '';
    };
    masterAddress = mkOption {
      type = str;
      default = "127.0.0.1";
      description = "Cluster-wide address of the Kubernetes master.";
    };
    apiserverAddress = mkOption {
      type = str;
      default = "https://127.0.0.1:6443";
      description = "Cluster-wide URL of the Kubernetes API server.";
    };
    clusterCidr = mkOption {
      type = nullOr str;
      default = "10.1.0.0/16";
      description = "CIDR range used for pods in the cluster.";
    };
    easyCerts = mkOption {
      type = bool;
      default = true;
      description = "Automatically generate x509 certificates for the cluster.";
    };
    dataDir = mkOption {
      type = path;
      default = "/var/lib/kubernetes";
      description = "Kubernetes state directory.";
    };
    featureGates = mkOption {
      type = attrsOf bool;
      default = { };
      description = "Kubernetes feature gates.";
    };
    extraPackages = mkOption {
      type = listOf package;
      default = with pkgs; [
        kubectl
        kubernetes-helm
      ];
      description = "Additional Kubernetes command-line packages installed on the host.";
    };
    openFirewall = mkEnableOption "Kubernetes firewall ports";
    extraOptions = mkOption {
      type = attrs;
      default = { };
      description = "Extra services.kubernetes NixOS options merged at top level.";
    };
  };

  config = mkIf cfg.enable {
    services.kubernetes = {
      inherit (cfg)
        package
        roles
        masterAddress
        apiserverAddress
        clusterCidr
        easyCerts
        dataDir
        featureGates
        ;
    }
    // cfg.extraOptions;

    environment.systemPackages = cfg.extraPackages;

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [
        10250
      ]
      ++ optionals (elem "master" cfg.roles) [
        6443
        2379
        2380
        10251
        10252
      ];
      allowedUDPPorts = optionals (elem "node" cfg.roles) [ 8472 ];
    };
  };
}
