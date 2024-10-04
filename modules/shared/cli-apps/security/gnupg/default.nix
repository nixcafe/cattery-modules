{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;
  inherit (lib) optionalAttrs;

  cfg = config.${namespace}.cli-apps.security.gnupg;
in
{
  options.${namespace}.cli-apps.security.gnupg = {
    enable = lib.mkEnableOption "gnupg";
    agent = {
      enable = lib.mkEnableOption "gnupg agent";
      enableSSHSupport = lib.mkEnableOption "gnupg agent ssh support";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        environment.systemPackages = with pkgs; [ gnupg ];
        programs.gnupg.agent = {
          inherit (cfg.agent) enable enableSSHSupport;
        };
      }

      (optionalAttrs isLinux {
        # SUID wrapper, not sure if i need this, but just to not bother my future self
        programs.mtr.enable = true;
        # enable udev rules for gnupg smart cards.
        hardware.gpgSmartcards.enable = true;
      })
    ]
  );

}
