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
      yubikey-manager-qt
      yubikey-manager
      yubico-piv-tool
    ];
    services = {
      pcscd.enable = true;
      yubikey-agent.enable = cfg.agent.enable;
    };
    programs.yubikey-touch-detector.enable = cfg.agent.enable;
  };

}
