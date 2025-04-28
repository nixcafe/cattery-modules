{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.system.fileSystems.btrfs.impermanence;
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

  config = {
    boot.initrd.postDeviceCommands = lib.mkAfter (
      builtins.concatStringsSep "\n" (
        map (x: ''
          mkdir ${x.tempDir}
          mount ${x.device} ${x.tempDir}
          if [[ -e ${x.tempDir}/${x.subvol} ]]; then
            mkdir -p ${x.tempDir}/${x.oldSubvolDir}
            timestamp=$(date --date="@$(stat -c %Y ${x.tempDir}/${x.subvol})" "+%Y-%m-%-d_%H:%M:%S")
            btrfs subvolume snapshot ${x.tempDir}/${x.subvol} "${x.tempDir}/${x.oldSubvolDir}/$timestamp"
            btrfs subvolume delete ${x.tempDir}/${x.subvol}
          fi

          delete_subvolume_recursively() {
            IFS=$'\n'
            for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "${x.tempDir}/$i"
            done
            btrfs subvolume delete "$1"
          }

          for i in $(find ${x.tempDir}/${x.oldSubvolDir}/ -maxdepth 1 -mtime +30); do
            delete_subvolume_recursively "$i"
          done

          btrfs subvolume create ${x.tempDir}/${x.subvol}
          umount ${x.tempDir}
        '') (builtins.attrValues cfg)
      )
    );
  };

}
