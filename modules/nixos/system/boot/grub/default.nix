{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.system.boot.grub;
in
{
  options.${namespace}.system.boot.grub = with types; {
    enable = lib.mkEnableOption "boot grub";
    device = mkOption {
      type = types.str;
      description = ''
        The device on which the GRUB boot loader will be installed.
        The special value `nodev` means that a GRUB
        boot menu will be generated, but GRUB itself will not
        actually be installed.  To install GRUB on multiple devices,
        use `boot.loader.grub.devices`.
      '';
      default = "";
      example = "/dev/disk/by-id/wwn-0x500001234567890a";
    };
    configurationLimit = mkOption {
      type = int;
      default = 100;
    };
  };

  # Legacy BIOS support
  config = lib.mkIf cfg.enable {
    boot.loader = {
      grub = {
        inherit (cfg) configurationLimit device;

        theme = "${pkgs.nixos-grub2-theme}";
      };
    };
  };
}
