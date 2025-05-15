{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;

  cfg = config.${namespace}.cli-apps.tool.ventoy;
in
{
  options.${namespace}.cli-apps.tool.ventoy = {
    enable = lib.mkEnableOption "ventoy";
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    home.packages = with pkgs; [
      ventoy-full # usb boot creator
    ];
  };

}
