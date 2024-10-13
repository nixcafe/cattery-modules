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
  };

  config = {
    fonts.fontconfig = {
      inherit (cfg) enable;
    };
  };

}
