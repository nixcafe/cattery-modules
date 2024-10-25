{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.file-manager.yazi;
in
{
  options.${namespace}.cli-apps.file-manager.yazi = {
    enable = lib.mkEnableOption "yazi file manager";
  };

  config = lib.mkIf cfg.enable {
    programs.yazi = {
      enable = true;
    };
  };

}
