{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optionals
    types
    ;

  cfg = config.${namespace}.services.k3s;
in
{
  options.${namespace}.services.k3s = with types; {
    enable = mkEnableOption "K3s Kubernetes";
    package = mkPackageOption pkgs "k3s" { };
    role = mkOption {
      type = enum [
        "server"
        "agent"
      ];
      default = "server";
      description = "Whether this node runs as a K3s server or agent.";
    };
    serverAddr = mkOption {
      type = str;
      default = "";
      example = "https://10.0.0.10:6443";
      description = "K3s server address used by agents or additional servers to join a cluster.";
    };
    tokenFile = mkOption {
      type = nullOr path;
      default = null;
      description = "File containing the K3s server token. Prefer this over putting a token in the Nix store.";
    };
    agentTokenFile = mkOption {
      type = nullOr path;
      default = null;
      description = "File containing the K3s agent token. Only used on server nodes.";
    };
    clusterInit = mkEnableOption "K3s embedded etcd cluster initialization";
    disableAgent = mkEnableOption "K3s server-only mode (do not run the local agent)";
    disable = mkOption {
      type = listOf str;
      default = [ ];
      example = [
        "traefik"
        "servicelb"
      ];
      description = "K3s packaged components to disable.";
    };
    extraFlags = mkOption {
      type = listOf str;
      default = [ ];
      description = "Additional flags passed to the K3s command.";
    };
    configPath = mkOption {
      type = nullOr path;
      default = null;
      description = "Path to a K3s YAML configuration file.";
    };
    nodeName = mkOption {
      type = nullOr str;
      default = null;
      description = "K3s node name.";
    };
    nodeIP = mkOption {
      type = nullOr str;
      default = null;
      description = "IP address advertised for this K3s node.";
    };
    manifests = mkOption {
      type = attrs;
      default = { };
      description = "K3s auto-deploying manifests, passed through to services.k3s.manifests.";
    };
    autoDeployCharts = mkOption {
      type = attrs;
      default = { };
      description = "K3s auto-deploying Helm charts, passed through to services.k3s.autoDeployCharts.";
    };
    charts = mkOption {
      type = attrs;
      default = { };
      description = "K3s local Helm charts, passed through to services.k3s.charts.";
    };
    extraPackages = mkOption {
      type = listOf package;
      default = with pkgs; [
        kubectl
        kubernetes-helm
      ];
      description = "Additional Kubernetes command-line packages installed on the host.";
    };
    openFirewall = mkEnableOption "K3s firewall ports";
    extraOptions = mkOption {
      type = attrs;
      default = { };
      description = "Extra services.k3s NixOS options merged at top level.";
    };
  };

  config = mkIf cfg.enable {
    services.k3s = {
      enable = true;
      inherit (cfg)
        package
        role
        serverAddr
        tokenFile
        agentTokenFile
        clusterInit
        disableAgent
        disable
        extraFlags
        configPath
        nodeName
        nodeIP
        manifests
        autoDeployCharts
        charts
        ;
    }
    // cfg.extraOptions;

    environment.systemPackages = cfg.extraPackages;

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [
        10250
      ]
      ++ optionals (cfg.role == "server") [
        6443
        2379
        2380
      ];
      allowedUDPPorts = [ 8472 ];
    };
  };
}
