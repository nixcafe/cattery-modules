{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  cfg = config.${namespace}.desktop.hyprland.theme.charm-cat.convention;
in
{
  options.${namespace}.desktop.hyprland.theme.charm-cat.convention = {
    enable = lib.mkEnableOption "charm-cat convention";
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    home.packages = with pkgs; [
      playerctl
    ];

    ${namespace}.desktop.hyprland = {
      require = [
        "convention.base"
        "convention.bind-operate"
        "convention.monitor"
        "convention.rules"
        "convention.style"
      ];
    };

    xdg.configFile = {
      # preventing nix gc
      "hypr/convention" = {
        source = ./lua;
        recursive = true;
      };
    };
  };

}
