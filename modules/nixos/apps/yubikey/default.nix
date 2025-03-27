{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.apps.yubikey;
in
{
  options.${namespace}.apps.yubikey = {
    enable = lib.mkEnableOption "yubikey";
    agent.enable = lib.mkEnableOption "yubikey agent";
    touch-detector.enable = lib.mkEnableOption "yubikey touch detector";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      yubikey-manager
      yubikey-personalization
      yubikey-personalization-gui
      yubico-piv-tool
      yubioath-flutter
    ];
    services = {
      pcscd.enable = true;
      udev.packages = [ pkgs.yubikey-personalization ];
      yubikey-agent.enable = cfg.agent.enable;
    };
    programs.yubikey-touch-detector.enable = cfg.agent.enable;
  };

}
