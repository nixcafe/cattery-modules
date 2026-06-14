{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.cli-apps.editor.helix;
in
{
  options.${namespace}.cli-apps.editor.helix = with types; {
    enable = lib.mkEnableOption "helix";
    extraOptions = mkOption {
      type = attrs;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.helix = {
      enable = true;
    }
    // cfg.extraOptions;
  };

}
