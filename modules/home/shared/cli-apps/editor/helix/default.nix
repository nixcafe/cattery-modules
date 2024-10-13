{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.editor.helix;
in
{
  options.${namespace}.cli-apps.editor.helix = {
    enable = lib.mkEnableOption "helix";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      helix
    ];
  };

}