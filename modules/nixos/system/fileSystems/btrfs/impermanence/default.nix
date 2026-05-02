{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;
  inherit (lib.${namespace}) escapeSystemdPath;

  cfg = config.${namespace}.system.fileSystems.btrfs.impermanence;

  deviceUnits = map (x: "${escapeSystemdPath x.device}.device") (builtins.attrValues cfg);
in
{
  options.${namespace}.system.fileSystems.btrfs.impermanence = mkOption {
    type = types.attrsOf (
      types.submodule (
        { name, config, ... }:
        {
          options = with types; {
            device = mkOption {
              type = str;
            };
            tempDir = mkOption {
              type = str;
              default = "/btrfs_${config.subvol}_tmp";
            };
            oldSubvolDir = mkOption {
              type = str;
              default = "old_${config.subvol}";
            };
            subvol = mkOption {
              type = str;
              default = name;
            };
          };
        }
      )
    );
    default = { };
  };

  config = lib.mkIf (deviceUnits != [ ]) {
    boot.initrd.systemd = {
      services.impermance-btrfs-rolling = {
        description = "Archiving existing BTRFS subvolume and creating a fresh one";
        # Specify dependencies explicitly
        unitConfig.DefaultDependencies = false;
        # The script needs to run to completion before this service is done
        serviceConfig = {
          Type = "oneshot";
          # NOTE: to be able to see errors in your script do this
          StandardOutput = "journal+console";
          StandardError = "journal+console";
        };
        # This service is required for boot to succeed
        requiredBy = [ "initrd.target" ];
        # Should complete before any file systems are mounted
        before = [ "sysroot.mount" ];

        requires = [
          "initrd-root-device.target"
        ]
        ++ deviceUnits;

        after = [
          "initrd-root-device.target"
          # Allow hibernation to resume before trying to alter any data
          "local-fs-pre.target"
        ]
        ++ deviceUnits;

        script = builtins.concatStringsSep "\n" (
          map (x: ''
            mkdir ${x.tempDir}
            mount -t btrfs -o user_subvol_rm_allowed ${x.device} ${x.tempDir}
            if [[ -e ${x.tempDir}/${x.subvol} ]]; then
              mkdir -p ${x.tempDir}/${x.oldSubvolDir}
              timestamp=$(date --date="@$(stat -c %Y ${x.tempDir}/${x.subvol})" "+%Y-%m-%-d_%H:%M:%S")
              btrfs subvolume snapshot ${x.tempDir}/${x.subvol} "${x.tempDir}/${x.oldSubvolDir}/$timestamp"
              btrfs subvolume delete ${x.tempDir}/${x.subvol}
            fi

            for old_subvol in $(find ${x.tempDir}/${x.oldSubvolDir}/ -maxdepth 1 -mtime +30); do
              btrfs subvolume delete -R "$old_subvol"
            done

            btrfs subvolume create ${x.tempDir}/${x.subvol}
            umount ${x.tempDir}
          '') (builtins.attrValues cfg)
        );
      };

      extraBin = {
        "mkdir" = "${pkgs.coreutils}/bin/mkdir";
        "date" = "${pkgs.coreutils}/bin/date";
        "stat" = "${pkgs.coreutils}/bin/stat";
        "find" = "${pkgs.findutils}/bin/find";
        "btrfs" = "${pkgs.btrfs-progs}/bin/btrfs";
      };
    };
  };

}
