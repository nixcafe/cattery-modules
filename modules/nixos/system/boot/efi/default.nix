{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.system.boot.efi;
in
{
  options.${namespace}.system.boot.efi = with types; {
    enable = lib.mkEnableOption "boot efi";
    configurationLimit = mkOption {
      type = int;
      default = 100;
    };
  };

  # UEFI support
  config = lib.mkIf cfg.enable {
    # use systemd-boot as the bootloader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.systemd-boot.configurationLimit = cfg.configurationLimit;

    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix
    boot.loader.systemd-boot.editor = false;
  };

}
