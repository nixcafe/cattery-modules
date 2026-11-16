{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkOption types;

  cfg = config.${namespace}.services.hydra-builder;
in
{
  options.${namespace}.services.hydra-builder = {
    enable = mkEnableOption "the Hydra build agent, which connects to the queue runner over gRPC";

    package = lib.mkPackageOption pkgs "hydra-builder" { };

    queueRunnerAddr = mkOption {
      type = types.singleLineStr;
      example = "http://hydra.example.org:50051";
      description = ''
        Address of the queue runner's gRPC endpoint. See
        `services.hydra.queueRunner.grpc` on the Hydra server.
      '';
    };

    settings = mkOption {
      type = types.attrs;
      default = { };
      example = {
        maxJobs = 4;
        systems = [ "x86_64-linux" ];
      };
      description = ''
        Builder settings written to `/etc/hydra/builder.toml`. Values omitted
        here fall back to the upstream defaults (for example `systems` and
        `supportedFeatures` are read from Nix).
      '';
    };

    authorizationFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Path to a file holding the authorization token. The token has to be
        listed in the queue runner's
        `services.hydra.queueRunner.settings.tokenPaths`.
      '';
    };

    mtls = mkOption {
      type = types.nullOr (
        types.submodule {
          options = {
            serverRootCaCertPath = mkOption { type = types.path; };
            clientCertPath = mkOption { type = types.path; };
            clientKeyPath = mkOption { type = types.path; };
            domainName = mkOption { type = types.singleLineStr; };
          };
        }
      );
      default = null;
      description = "mTLS material used to authenticate against the queue runner.";
    };

    extraOptions = mkOption {
      type = types.attrs;
      default = { };
      description = "Extra options merged into `services.hydra-builder`.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.hydra-builder = {
      enable = true;
      inherit (cfg)
        package
        queueRunnerAddr
        authorizationFile
        mtls
        settings
        ;
    }
    // cfg.extraOptions;
  };
}
