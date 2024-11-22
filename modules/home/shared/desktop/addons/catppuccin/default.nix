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
    extraOptions = mkOption {
      type = attrs;
      default = user.settings.catppuccin or { };
    };
  };

  config = lib.mkIf cfg.enable {
    catppuccin = {
      enable = true;
    } // cfg.extraOptions;
  };
}
