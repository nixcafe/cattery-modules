{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;
  inherit (config.${namespace}.user) settings;

  cfg = config.${namespace}.apps.ghostty;
in
{
  options.${namespace}.apps.ghostty = with types; {
    enable = lib.mkEnableOption "ghostty";
    settings = mkOption {
      type = attrs;
      default = settings.ghostty.settings or { };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.ghostty = {
      inherit (cfg) settings;
      enable = true;
    };
  };

}
