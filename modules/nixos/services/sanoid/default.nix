{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.services.sanoid;
in
{
  options.${namespace}.services.sanoid = with types; {
    enable = lib.mkEnableOption "sanoid zfs snapshot";
    useWizard = lib.mkEnableOption "sanoid use host config";
    configFile = {
      settingsPath = mkOption {
        type = path;
        default = "/etc/sanoid/sanoid.conf";
        description = "Path to the Sanoid configuration file.";
      };
    };
    templates = mkOption {
      type = attrs;
      default = { };
      description = "Sanoid snapshot templates.";
    };
    datasets = mkOption {
      type = attrs;
      default = { };
      description = "Sanoid dataset configurations.";
    };
    interval = mkOption {
      type = str;
      default = "hourly";
      example = "daily";
      description = ''
        Run sanoid at this interval (systemd.time format).
        The default is to run hourly.
      '';
    };
    extraArgs = mkOption {
      type = listOf str;
      default = [ ];
      example = [
        "--verbose"
        "--debug"
      ];
      description = "Extra arguments passed to the sanoid command.";
    };
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
    extraOptions = mkOption {
      type = attrs;
      default = { };
      description = "Extra services.sanoid NixOS options merged at top level.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.sanoid = {
      enable = true;
      inherit (cfg)
        interval
        extraArgs
        templates
        datasets
        ;
    }
    // cfg.extraOptions;

    ${namespace}.system.impermanence = lib.mkIf (!cfg.useWizard && cfg.persistence) {
      directories = [
        "/etc/sanoid"
      ];
    };
  };
}
