{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.cli-apps.tool.hyfetch;
in
{
  options.${namespace}.cli-apps.tool.hyfetch = with types; {
    enable = lib.mkEnableOption "hyfetch";
    settings = mkOption {
      type = attrs;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.hyfetch = {
      enable = true;
      inherit (cfg) settings;
    };
  };

}
