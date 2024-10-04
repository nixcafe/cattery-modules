{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.security.fido2;
in
{
  options.${namespace}.cli-apps.security.fido2 = {
    enable = lib.mkEnableOption "fido2";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      libfido2
    ];
  };

}
