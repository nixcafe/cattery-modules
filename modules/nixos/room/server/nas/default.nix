{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types mkDefault;
  inherit (lib.${namespace}.module) mkDefaultEnabled;

  cfg = config.${namespace}.room.server.nas;

  mkServiceOption =
    desc:
    mkOption {
      type = types.bool;
      default = true;
      description = desc;
    };
in
{
  options.${namespace}.room.server.nas = {
    enable = lib.mkEnableOption "room server nas";

    samba = {
      enable = mkServiceOption "samba server";
    };
    avahi = {
      enable = mkServiceOption "avahi mDNS";
    };
    zfs = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "zfs file system. Requires `networking.hostId` to be set.";
      };
    };
    samba-wsdd = {
      enable = mkServiceOption "samba wsdd";
    };
    sanoid = {
      enable = mkServiceOption "sanoid zfs snapshot";
    };
    syncoid = {
      enable = mkServiceOption "syncoid zfs replication";
    };
    beszel = {
      enable = mkServiceOption "beszel monitoring";
      hub.enable = mkOption {
        type = types.bool;
        default = true;
        description = "beszel hub (web dashboard). Set false if running hub in Docker.";
      };
      agent.enable = mkOption {
        type = types.bool;
        default = true;
        description = "beszel agent (data collector). Set false if running agent in Docker.";
      };
    };
    netdata = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "netdata monitoring. Heavy, conflicts with beszel.";
      };
    };
    nfs = {
      enable = mkServiceOption "nfs server";
    };
    target = {
      enable = mkServiceOption "target iscsi";
    };
  };

  config = lib.mkIf cfg.enable {
    ${namespace} = {
      room.server = mkDefaultEnabled;

      services = {
        samba = lib.mkIf cfg.samba.enable {
          enable = mkDefault true;
          openFirewall = mkDefault true;
        };
        avahi = lib.mkIf cfg.avahi.enable {
          enable = mkDefault true;
          openFirewall = mkDefault true;
        };
        samba-wsdd = lib.mkIf cfg.samba-wsdd.enable {
          enable = mkDefault true;
          openFirewall = mkDefault true;
        };
        sanoid = lib.mkIf cfg.sanoid.enable mkDefaultEnabled;
        syncoid = lib.mkIf cfg.syncoid.enable mkDefaultEnabled;
        beszel = lib.mkIf cfg.beszel.enable {
          enable = mkDefault true;
          openFirewall = mkDefault true;
          hub.enable = mkDefault cfg.beszel.hub.enable;
          agent.enable = mkDefault cfg.beszel.agent.enable;
        };
        netdata = lib.mkIf cfg.netdata.enable mkDefaultEnabled;
        nfs = lib.mkIf cfg.nfs.enable {
          enable = mkDefault true;
          openFirewall = mkDefault true;
        };
        target = lib.mkIf cfg.target.enable {
          enable = mkDefault true;
          openFirewall = mkDefault true;
        };
      };

      system.fileSystems.zfs = lib.mkIf cfg.zfs.enable mkDefaultEnabled;
    };

    # disable sudo password
    security.sudo.wheelNeedsPassword = false;
  };
}
