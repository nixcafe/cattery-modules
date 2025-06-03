{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.services.qemu-guest;
in
{
  options.${namespace}.services.qemu-guest = {
    enable = lib.mkEnableOption "qemu guest";
  };

  config = lib.mkIf cfg.enable {
    services.qemuGuest.enable = true;
  };

}
