{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib)
    escapeShellArgs
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optional
    optionals
    types
    ;

  cfg = config.${namespace}.services.flintlock;
in
{
  options.${namespace}.services.flintlock = with types; {
    enable = mkEnableOption "Flintlock microVM lifecycle service";
    package = mkPackageOption pkgs "flintlock" { };
    firecrackerPackage = mkPackageOption pkgs "firecracker" { };
    virtiofsdPackage = mkPackageOption pkgs "virtiofsd" { };

    stateDir = mkOption {
      type = path;
      default = "/var/lib/flintlock";
      description = "Directory for Flintlock runtime state.";
    };
    socketDir = mkOption {
      type = path;
      default = "/run/flintlock";
      description = "Directory for per-microVM Unix sockets.";
    };
    containerdSocket = mkOption {
      type = str;
      default = "/run/containerd/containerd.sock";
      description = "Path to the containerd socket.";
    };
    containerdNamespace = mkOption {
      type = str;
      default = "flintlock";
      description = "containerd namespace used by Flintlock.";
    };

    grpcEndpoint = mkOption {
      type = str;
      default = "127.0.0.1:9090";
      description = "Address on which the Flintlock gRPC API listens.";
    };
    enableHttp = mkOption {
      type = bool;
      default = false;
      description = "Expose the gRPC API through Flintlock's HTTP gateway.";
    };
    httpEndpoint = mkOption {
      type = str;
      default = "127.0.0.1:8090";
      description = "Address on which the Flintlock HTTP gateway listens.";
    };

    insecure = mkOption {
      type = bool;
      default = true;
      description = ''
        Run the API without TLS. This is convenient for a local-only
        endpoint, but should be disabled before exposing Flintlock remotely.
      '';
    };
    tlsCert = mkOption {
      type = nullOr path;
      default = null;
      description = "TLS certificate used when `insecure` is false.";
    };
    tlsKey = mkOption {
      type = nullOr path;
      default = null;
      description = "TLS private key used when `insecure` is false.";
    };

    parentInterface = mkOption {
      type = nullOr str;
      default = null;
      example = "eth0";
      description = ''
        Parent network interface for macvtap-backed microVM networking.
        Exactly one of `parentInterface` and `bridgeName` must be set.
      '';
    };
    bridgeName = mkOption {
      type = nullOr str;
      default = null;
      example = "br0";
      description = ''
        Existing Linux bridge to attach microVM tap devices to.
        Exactly one of `parentInterface` and `bridgeName` must be set.
      '';
    };

    enableExecApi = mkOption {
      type = bool;
      default = false;
      description = "Expose the guest exec API for running commands inside microVMs.";
    };
    enableSshProxyApi = mkOption {
      type = bool;
      default = false;
      description = "Expose the SSH proxy API for tunneling into microVMs.";
    };
    verbosity = mkOption {
      type = int;
      default = 2;
      description = "Flintlock logging verbosity. Levels 2 and above include debug output.";
    };
    extraFlags = mkOption {
      type = listOf str;
      default = [ ];
      description = "Additional command-line flags passed to `flintlockd run`.";
    };
  };

  config = mkIf cfg.enable {
    ${namespace}.services = {
      containerd.enable = mkDefault true;
      firecracker.enable = mkDefault true;
    };

    assertions = [
      {
        assertion = (cfg.parentInterface != null) != (cfg.bridgeName != null);
        message = "cattery.services.flintlock: set exactly one of parentInterface or bridgeName";
      }
      {
        assertion = cfg.insecure || (cfg.tlsCert != null && cfg.tlsKey != null);
        message = "cattery.services.flintlock: tlsCert and tlsKey are required when insecure = false";
      }
    ];

    systemd.tmpfiles.rules = [
      "d ${cfg.stateDir} 0750 root root -"
      "d ${cfg.socketDir} 0750 root root -"
    ];

    systemd.services.flintlockd = {
      description = "Flintlock microVM lifecycle service";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      requires = [ "containerd.service" ];
      after = [
        "containerd.service"
        "network-online.target"
        "systemd-tmpfiles-setup.service"
      ];

      path = [
        cfg.package
        cfg.firecrackerPackage
        pkgs.containerd
        pkgs.cni-plugins
        pkgs.iproute2
      ];

      serviceConfig = {
        ExecStart = escapeShellArgs (
          [
            "${cfg.package}/bin/flintlockd"
            "run"
            "--containerd-socket"
            cfg.containerdSocket
            "--containerd-ns"
            cfg.containerdNamespace
            "--firecracker-bin"
            "${cfg.firecrackerPackage}/bin/firecracker"
            "--virtiofs-bin"
            "${cfg.virtiofsdPackage}/bin/virtiofsd"
            "--state-dir"
            cfg.stateDir
            "--socket-dir"
            cfg.socketDir
            "--grpc-endpoint"
            cfg.grpcEndpoint
            "--verbosity"
            (toString cfg.verbosity)
          ]
          ++ optionals (cfg.parentInterface != null) [
            "--parent-iface"
            cfg.parentInterface
          ]
          ++ optionals (cfg.bridgeName != null) [
            "--bridge-name"
            cfg.bridgeName
          ]
          ++ optional cfg.enableHttp "--enable-http"
          ++ optionals cfg.enableHttp [
            "--http-endpoint"
            cfg.httpEndpoint
          ]
          ++ optional cfg.enableExecApi "--enable-exec-api"
          ++ optional cfg.enableSshProxyApi "--enable-ssh-proxy-api"
          ++ optional cfg.insecure "--insecure"
          ++ optionals (!cfg.insecure) [
            "--tls-cert"
            cfg.tlsCert
            "--tls-key"
            cfg.tlsKey
          ]
          ++ cfg.extraFlags
        );
        Restart = "on-failure";
        RestartSec = 5;
        LimitNOFILE = 65536;
      };

      unitConfig = {
        StartLimitIntervalSec = 10;
        StartLimitBurst = 3;
      };
    };
  };
}
