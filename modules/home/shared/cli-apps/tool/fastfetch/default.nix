{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.cli-apps.tool.fastfetch;
in
{
  options.${namespace}.cli-apps.tool.fastfetch = with types; {
    enable = lib.mkEnableOption "fastfetch";
    settings = mkOption {
      type = attrs;
      default = { };
      description = "Fastfetch configuration settings.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.fastfetch = {
      inherit (cfg) settings;
      enable = true;
    };
  };

}
