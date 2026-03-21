{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    ;

  cfg = config.${namespace}.apps.yubikey;
in
{
  options.${namespace}.apps.yubikey = {
    enable = mkEnableOption "yubikey";
    agent.enable = mkEnableOption "yubikey agent";
    touch-detector.enable = mkEnableOption "yubikey touch detector";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      yubikey-manager
      yubikey-personalization
      yubico-piv-tool
      yubioath-flutter
    ];

    services = {
      pcscd.enable = true;
      udev.packages = [ pkgs.yubikey-personalization ];
      yubikey-agent.enable = cfg.agent.enable;
    };
    programs.yubikey-touch-detector.enable = cfg.agent.enable;

    ${namespace}.home.extraOptions = {
      programs.gpg = {
        # conflict prevention with pcscd
        scdaemonSettings = {
          disable-ccid = true;
          pcsc-shared = true;
        };
      };

      home.sessionVariables = {
        YKCS11_PROVIDER = "${pkgs.yubico-piv-tool}/lib/libykcs11.so";
      };

      services.ssh-agent = {
        pkcs11Whitelist = [
          "${pkgs.yubico-piv-tool}/lib/*"
        ];
      };
    };
  };

}
