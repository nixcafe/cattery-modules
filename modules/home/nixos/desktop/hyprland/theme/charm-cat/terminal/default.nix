{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.desktop.hyprland.theme.charm-cat.terminal;
in
{
  options.${namespace}.desktop.hyprland.theme.charm-cat.terminal = {
    enable = lib.mkEnableOption "charm-cat terminal";
  };

  config = lib.mkIf cfg.enable {
    # kitty
    programs.kitty = {
      enable = true;
    };

    ${namespace}.desktop.hyprland = {
      require = [
        "terminal.kitty"
      ];
    };

    xdg.configFile = {
      # preventing nix gc
      "hypr/terminal" = {
        source = ./lua;
        recursive = true;
      };
    };
  };
}
