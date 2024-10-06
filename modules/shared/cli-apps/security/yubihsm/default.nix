{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.security.yubihsm;
in
{
  options.${namespace}.cli-apps.security.yubihsm = {
    enable = lib.mkEnableOption "yubihsm";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      yubihsm-shell
      yubihsm-connector
    ];
  };

}
