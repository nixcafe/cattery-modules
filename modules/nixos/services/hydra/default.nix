{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.services.hydra;
in
{
  options.${namespace}.services.hydra = with types; {
    enable = lib.mkEnableOption "hydra";
    openFirewall = lib.mkEnableOption "hydra web interface";
    hydraURL = mkOption {
      type = str;
      description = ''
        The base URL for the Hydra web interface. Used for links in emails.
      '';
    };
    port = mkOption {
      type = port;
      default = 3000;
      description = ''
        TCP port the Hydra web server should listen to.
      '';
    };
    listenHost = mkOption {
      type = str;
      default = "*";
      example = "localhost";
      description = ''
        The hostname or address Hydra listens on.
        `*` means all interfaces.
      '';
    };
    notificationSender = mkOption {
      type = str;
      description = ''
        Sender email address used for Hydra email notifications.
      '';
    };
    smtpHost = mkOption {
      type = nullOr str;
      default = null;
      example = "localhost";
      description = ''
        Hostname of the SMTP server to use for sending email.
      '';
    };
    useSubstitutes = mkOption {
      type = bool;
      default = false;
      description = ''
        Whether to use binary caches for building Hydra jobs.
      '';
    };
    minimumDiskFree = mkOption {
      type = int;
      default = 0;
      description = ''
        Threshold of minimum disk space (GiB) before the
        queue runner stalls.
      '';
    };
    minimumDiskFreeEvaluator = mkOption {
      type = int;
      default = 0;
      description = ''
        Threshold of minimum disk space (GiB) before the
        evaluator stalls.
      '';
    };
    extraConfig = mkOption {
      type = lines;
      default = "";
      description = ''
        Extra lines appended to the Hydra configuration file.
      '';
    };
    extraOptions = mkOption {
      type = attrs;
      default = { };
      description = ''
        Extra options merged into the Hydra service configuration.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    services.hydra = {
      inherit (cfg)
        enable
        hydraURL
        port
        listenHost
        notificationSender
        smtpHost
        useSubstitutes
        minimumDiskFree
        minimumDiskFreeEvaluator
        ;
    }
    // (lib.optionalAttrs (cfg.extraConfig != "") {
      extraConfig = lib.mkAfter cfg.extraConfig;
    })
    // cfg.extraOptions;
  };
}
