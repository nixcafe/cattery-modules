{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;

  cfg = config.${namespace}.apps.science;
in
{
  options.${namespace}.apps.science = {
    enable = lib.mkEnableOption "science";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    home.packages = with pkgs; [ geogebra6 ];

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      xdg.config.directories = [
        "GeoGebra"
      ];
    };
  };

}
