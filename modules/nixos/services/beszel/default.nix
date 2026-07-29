{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.services.beszel;

  envPath =
    let
      files = builtins.attrNames cfg.secrets.etc.files;
    in
    if files != [ ] then "/etc/${builtins.head files}" else null;
in
{
  options.${namespace}.services.beszel = with types; {
    enable = lib.mkEnableOption "beszel monitoring";
    openFirewall = mkOption {
      type = bool;
      default = false;
      description = "Open beszel hub port (TCP 8090 by default) in the firewall.";
    };
    hub = {
      enable = mkOption {
        type = bool;
        default = true;
        description = "Enable beszel hub (web dashboard). Set to false if running hub in Docker.";
      };
      host = mkOption {
        type = str;
        default = "127.0.0.1";
        description = "Host address for the beszel hub web UI.";
      };
      port = mkOption {
        type = port;
        default = 8090;
        description = "Port for the beszel hub web UI.";
      };
    };
    agent = {
      enable = mkOption {
        type = bool;
        default = true;
        description = "Enable beszel agent (data collector). Set to false if running agent in Docker.";
      };
      environmentFile = mkOption {
        type = nullOr path;
        default = null;
        description = "Path to environment file for the beszel agent. Defaults to /etc/beszel/env/agent.env when secrets are enabled.";
      };
      smartmon.enable = mkOption {
        type = bool;
        default = true;
        description = "Enable S.M.A.R.T. disk monitoring in beszel agent.";
      };
    };
    extraOptions = mkOption {
      type = attrs;
      default = { };
      description = "Extra options merged at services.beszel level.";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall = lib.mkIf (cfg.openFirewall && cfg.hub.enable) {
      allowedTCPPorts = [ cfg.hub.port ];
    };

    services.beszel = {
      hub = {
        enable = cfg.hub.enable;
        inherit (cfg.hub) host port;
      };
      agent = {
        enable = cfg.agent.enable;
        smartmon.enable = cfg.agent.smartmon.enable;
        environmentFile =
          if cfg.agent.environmentFile != null then
            cfg.agent.environmentFile
          else if cfg.secrets.enable then
            envPath
          else
            null;
      };
    }
    // cfg.extraOptions;
  };
}
