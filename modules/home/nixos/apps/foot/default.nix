{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;
  inherit (config.${namespace}.user) settings;

  cfg = config.${namespace}.apps.foot;
in
{
  options.${namespace}.apps.foot = with types; {
    enable = lib.mkEnableOption "foot";
    settings = mkOption {
      type = attrs;
      default = settings.foot.settings or { };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.foot = {
      inherit (cfg) settings;
      enable = true;
    };
  };

}
