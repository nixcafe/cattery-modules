{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.security.gnupg;
in
{
  options.${namespace}.cli-apps.security.gnupg = {
    enable = lib.mkEnableOption "gnupg";
  };

  config = lib.mkIf cfg.enable {
    # SUID wrapper, not sure if i need this, but just to not bother my future self
    programs.mtr.enable = true;
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    # enable udev rules for gnupg smart cards.
    hardware.gpgSmartcards.enable = true;
  };

}
