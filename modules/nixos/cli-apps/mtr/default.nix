{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.mtr;
in
{
  options.${namespace}.cli-apps.mtr = {
    enable = lib.mkEnableOption "mtr";
  };

  config = lib.mkIf cfg.enable {
    programs.mtr.enable = true;
  };

}
