{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.desktop.hyprland.theme.charm-cat.convention;
in
{
  options.${namespace}.desktop.hyprland.theme.charm-cat.convention = {
    enable = lib.mkEnableOption "charm-cat convention";
  };

  config = lib.mkIf cfg.enable {
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
