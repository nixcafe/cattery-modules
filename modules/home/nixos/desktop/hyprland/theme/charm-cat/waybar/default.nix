{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  cfg = config.${namespace}.desktop.hyprland.theme.charm-cat.waybar;
in
{
  options.${namespace}.desktop.hyprland.theme.charm-cat.waybar = {
    enable = lib.mkEnableOption "charm-cat waybar";
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    programs.waybar = {
      enable = true;
      settings = [ (builtins.fromJSON (builtins.readFile ./conf/config.json)) ];
      style = builtins.readFile ./conf/style.css;
      systemd.enable = true;
    };
  };
}
