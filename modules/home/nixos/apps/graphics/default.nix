{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;

  cfg = config.${namespace}.apps.graphics;
in
{
  options.${namespace}.apps.graphics = {
    enable = lib.mkEnableOption "graphics";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    home.packages = with pkgs; [
      gimp
      inkscape-with-extensions
      nomacs
      imv
      krita
    ];

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      xdg = {
        data.directories = [
          "krita"
          "nomacs"
        ];
        config = {
          files = [
            "kritarc"
          ];
          directories = [
            "GIMP"
            "nomacs"
            "inkscape"
          ];
        };
      };
    };
  };

}
