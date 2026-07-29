{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types optionalAttrs;

  cfg = config.${namespace}.services.samba;
in
{
  options.${namespace}.services.samba = with types; {
    enable = lib.mkEnableOption "samba server";
    openFirewall = mkOption {
      type = bool;
      default = false;
      description = "Open Samba ports (TCP 139, 445) in the firewall.";
    };
    useWizard = lib.mkEnableOption "samba use host config";
    configFile = {
      settingsPath = mkOption {
        type = path;
        default = "/etc/samba/smb.conf";
        description = "Path to the Samba smb.conf configuration file.";
      };
    };
    settings = mkOption {
      type = attrs;
      default = { };
      description = "Samba smb.conf settings merged at services.samba.settings.";
    };
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
    extraOptions = mkOption {
      type = attrs;
      default = { };
      description = "Extra services.samba NixOS options merged at top level.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.samba = {
      enable = true;
      inherit (cfg) openFirewall;
    }
    // optionalAttrs (!cfg.useWizard) {
      inherit (cfg) settings;
    }
    // cfg.extraOptions;

    ${namespace}.system.impermanence = lib.mkIf (!cfg.useWizard && cfg.persistence) {
      directories = [
        "/etc/samba"
      ];
    };
  };
}
