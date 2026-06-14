{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib) mkDefault;

  cfg = config.${namespace}.desktop.hyprland.theme.charm-cat;
in
{
  options.${namespace}.desktop.hyprland.theme.charm-cat = {
    enable = lib.mkEnableOption "charm-cat theme";
    greetd = {
      enable = lib.mkEnableOption "greetd for hyprland" // {
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # greetd for login
    services.greetd = lib.mkIf cfg.greetd.enable {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd start-hyprland";
          user = "greeter";
        };
      };
    };

    # hyprland and wayland
    security.pam.services.hyprlock = { };

    ${namespace}.desktop.hyprland = {
      enable = mkDefault true;
    };
  };
}
