{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.services.adguardhome;

  # whole config via agenix secret, takes precedence over declarative settings
  secretConfigScript = pkgs.writeShellScript "adguardhome-secret-config" ''
    if [ -f "/etc/adguardhome/AdGuardHome.yaml" ]; then
      install -m 600 /etc/adguardhome/AdGuardHome.yaml "$STATE_DIRECTORY/AdGuardHome.yaml"
    fi
  '';
in
{
  options.${namespace}.services.adguardhome = with types; {
    enable = lib.mkEnableOption "adguardhome";
    package = lib.mkPackageOption pkgs "adguardhome" { };
    openFirewall = mkOption {
      type = bool;
      default = false;
      description = "Open the AdGuard Home web interface port (TCP) in the firewall. Does not open the port needed to access the DNS resolver.";
    };
    allowDHCP = mkOption {
      type = bool;
      default = cfg.settings.dhcp.enabled or false;
      description = "Allow AdGuard Home to open raw sockets (CAP_NET_RAW), required for the integrated DHCP server.";
    };
    mutableSettings = mkOption {
      type = bool;
      default = true;
      description = "Allow changes made on the AdGuard Home web interface to persist between service restarts.";
    };
    host = mkOption {
      type = str;
      default = "0.0.0.0";
      description = "Host address to bind the HTTP server to.";
    };
    port = mkOption {
      type = port;
      default = 3000;
      description = "Port to serve HTTP pages on.";
    };
    settings = mkOption {
      type = nullOr attrs;
      default = null;
      description = ''
        AdGuard Home configuration. Refer to
        <https://github.com/AdguardTeam/AdGuardHome/wiki/Configuration#configuration-file>
        for details on supported values.

        Ignored when {option}`useWizard` is enabled.
      '';
    };
    useWizard =
      lib.mkEnableOption "use the host AdGuardHome.yaml configuration file instead of declarative settings"
      // {
        description = ''
          Whether to use the full AdGuardHome.yaml config file managed through agenix
          instead of declarative {option}`settings`. Requires the agenix secret
          `adguardhome/AdGuardHome.yaml` declared under `cattery.secrets`.
        '';
      };
    extraArgs = mkOption {
      type = listOf str;
      default = [ ];
      description = "Extra command line parameters passed to the adguardhome binary.";
    };
    extraOptions = mkOption {
      type = attrs;
      default = { };
      description = "Extra services.adguardhome NixOS options merged at top level.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.adguardhome = {
      enable = true;
      inherit (cfg)
        package
        openFirewall
        allowDHCP
        mutableSettings
        host
        port
        extraArgs
        ;
      settings = lib.mkIf (!cfg.useWizard) cfg.settings;
    }
    // cfg.extraOptions;

    systemd.services.adguardhome = lib.mkIf (cfg.useWizard && cfg.secrets.enable) {
      serviceConfig.ExecStartPre = lib.mkAfter [
        "+${secretConfigScript}"
      ];
    };
  };
}
