{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  cfg = config.${namespace}.desktop.hyprland.addons.hyprshot;
in
{
  options.${namespace}.desktop.hyprland.addons.hyprshot = {
    enable = lib.mkEnableOption "hyprshot";
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    home.packages = with pkgs; [
      hyprshot # screenshot
      wl-clipboard # for hyprshot
      grim # for hyprshot
      slurp # for hyprshot
    ];

    # examples: -m output -o ~/Pictures/Screenshots -- nomacs
  };

}
