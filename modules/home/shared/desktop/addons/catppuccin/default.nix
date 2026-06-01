{
  lib,
  config,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;
  inherit (config.${namespace}) user;

  cfg = config.${namespace}.desktop.addons.catppuccin;
in
{
  options.${namespace}.desktop.addons.catppuccin = with types; {
    enable = lib.mkEnableOption "catppuccin";
    autoEnable = lib.mkEnableOption "all Catppuccin integrations by default" // {
      default = cfg.enable;
    };
    extraOptions = mkOption {
      type = attrs;
      default = user.settings.catppuccin.home or { };
    };
  };

  config = lib.mkIf cfg.enable {
    catppuccin = {
      inherit (cfg) autoEnable;

      enable = true;
    }
    // cfg.extraOptions;
  };
}
