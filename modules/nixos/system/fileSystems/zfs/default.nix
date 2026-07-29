{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.system.fileSystems.zfs;
in
{
  options.${namespace}.system.fileSystems.zfs = with types; {
    enable = lib.mkEnableOption "zfs file system. Requires `networking.hostId` to be set";
    autoScrub = {
      enable = mkOption {
        type = bool;
        default = true;
        description = "Enable periodic ZFS pool scrubbing.";
      };
      interval = mkOption {
        type = str;
        default = "weekly";
        description = "ZFS scrub interval (weekly, monthly, etc.).";
      };
    };
    autoSnapshot = {
      enable = mkOption {
        type = bool;
        default = false;
        description = "Enable automatic ZFS snapshots.";
      };
    };
    trim = {
      enable = mkOption {
        type = bool;
        default = true;
        description = "Enable periodic TRIM for SSDs in ZFS pools.";
      };
      interval = mkOption {
        type = str;
        default = "weekly";
        description = "ZFS TRIM interval (weekly, monthly, etc.).";
      };
    };
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
    extraOptions = mkOption {
      type = attrs;
      default = { };
      description = "Extra ZFS NixOS options merged at top level.";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.supportedFilesystems = [ "zfs" ];

    services.zfs = {
      autoScrub = lib.mkIf cfg.autoScrub.enable {
        inherit (cfg.autoScrub) enable interval;
      };
      autoSnapshot = lib.mkIf cfg.autoSnapshot.enable {
        enable = true;
      };
      trim = lib.mkIf cfg.trim.enable {
        inherit (cfg.trim) enable interval;
      };
    }
    // cfg.extraOptions;

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      directories = [
        "/etc/zfs"
      ];
    };
  };
}
