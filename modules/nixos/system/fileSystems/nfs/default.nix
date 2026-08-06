{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    nameValuePair
    mergeAttrsList
    mapAttrsToList
    mapAttrs'
    ;

  cfg = config.${namespace}.system.fileSystems.nfs;

  # type
  nfsType = types.submodule (_: {
    options = with types; {
      server = mkOption {
        type = str;
        default = "";
        description = "NFS server host or IP address.";
      };
      mounts = mkOption {
        type = attrsOf mountType;
        default = { };
        description = "NFS export bindings mapping export names to their mount configuration.";
      };
    };
  });
  mountType = types.submodule (
    { name, ... }:
    {
      options = with types; {
        export = mkOption {
          type = str;
          default = "";
          description = "Remote export path on the NFS server (e.g. /export/data).";
        };
        mountPoint = mkOption {
          type = str;
          default = "/mnt/${name}";
          description = "Local mount point.";
        };
        autoMountOpts = mkOption {
          type = str;
          default = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
          description = "Systemd automount options to prevent hanging on network split.";
        };
        extraOptions = mkOption {
          type = listOf str;
          default = [ ];
          description = "Extra NFS mount options for this mount.";
        };
      };
    }
  );

  # object
  toFileSystem =
    _: value:
    (mapAttrs' (
      _: value2:
      nameValuePair value2.mountPoint {
        device = "${value.server}:${value2.export}";
        fsType = "nfs";
        options = [ value2.autoMountOpts ] ++ value2.extraOptions;
      }
    ) value.mounts);
in
{
  options.${namespace}.system.fileSystems.nfs = with types; {
    enable = lib.mkEnableOption "nfs client";
    client = mkOption {
      type = attrsOf nfsType;
      default = { };
      description = "NFS client server configurations keyed by server name.";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.supportedFilesystems = [ "nfs" ];

    fileSystems = mergeAttrsList (mapAttrsToList toFileSystem cfg.client);
  };
}
