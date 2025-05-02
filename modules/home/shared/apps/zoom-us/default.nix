{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.apps.zoom-us;
in
{
  options.${namespace}.apps.zoom-us = {
    enable = lib.mkEnableOption "zoom-us";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      zoom-us
    ];
  };

}
