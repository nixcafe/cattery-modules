{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.system.fonts;
in
{
  options.${namespace}.system.fonts = {
    enable = lib.mkEnableOption "fonts";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = {
    fonts.fontconfig = {
      inherit (cfg) enable;
    };

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      xdg.cache.directories = [ "fontconfig" ];
    };
  };

}
