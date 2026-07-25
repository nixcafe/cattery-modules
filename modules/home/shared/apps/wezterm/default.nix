{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;
  inherit (config.${namespace}.user) settings;

  cfg = config.${namespace}.apps.wezterm;
in
{
  options.${namespace}.apps.wezterm = with types; {
    enable = lib.mkEnableOption "wezterm";
    extraConfig = mkOption {
      type = lines;
      default = settings.wezterm.extraConfig or "return {}";
      description = ''
        Extra Lua configuration for WezTerm.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    programs.wezterm = {
      inherit (cfg) extraConfig;
      enable = true;
    };
  };

}
