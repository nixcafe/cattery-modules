{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.services.target;
in
{
  options.${namespace}.services.target = with types; {
    enable = lib.mkEnableOption "target iscsi lio";
    openFirewall = mkOption {
      type = bool;
      default = false;
      description = "Open iSCSI port (TCP 3260) in the firewall.";
    };
    useWizard = lib.mkEnableOption "target use host config";
    configFile = {
      enable = lib.mkEnableOption "target config file";
      settingsPath = mkOption {
        type = path;
        default = "/etc/target/saveconfig.json";
        description = "Path to the LIO target configuration file.";
      };
    };
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
    extraOptions = mkOption {
      type = attrs;
      default = { };
      description = "Extra services.target NixOS options merged at top level.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.target = {
      enable = true;
    }
    // cfg.extraOptions;

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ 3260 ];
    };

    ${namespace}.system.impermanence = lib.mkIf (!cfg.useWizard && cfg.persistence) {
      directories = [
        "/etc/target"
      ];
    };
  };
}
