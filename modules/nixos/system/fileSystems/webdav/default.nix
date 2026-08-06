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

  cfg = config.${namespace}.system.fileSystems.webdav;

  # type
  webdavType = types.submodule (
    { name, ... }:
    {
      options = with types; {
        url = mkOption {
          type = str;
          default = "";
          description = "Base URL of the WebDAV server (e.g. https://cloud.example.com/remote.php/dav/files/user).";
        };
        mounts = mkOption {
          type = attrsOf (mountType name);
          default = { };
          description = "WebDAV bindings mapping mount names to their mount configuration.";
        };
      };
    }
  );
  mountType =
    davName:
    types.submodule (
      { name, ... }:
      {
        options = with types; {
          path = mkOption {
            type = str;
            default = "";
            description = "Path under the base URL to mount (e.g. /documents).";
          };
          mountPoint = mkOption {
            type = str;
            default = "/mnt/${davName}/${name}";
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
            description = "Extra davfs2 mount options for this mount.";
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
        device = "${value.url}${value2.path}";
        fsType = "davfs";
        options = [ value2.autoMountOpts ] ++ value2.extraOptions;
      }
    ) value.mounts);
in
{
  options.${namespace}.system.fileSystems.webdav = with types; {
    enable = lib.mkEnableOption "webdav client (davfs2)";
    client = mkOption {
      type = attrsOf webdavType;
      default = { };
      description = "WebDAV client server configurations keyed by server name.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.davfs2.enable = true;

    fileSystems = mergeAttrsList (mapAttrsToList toFileSystem cfg.client);
  };
}
