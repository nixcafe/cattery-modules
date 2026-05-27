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
  };

  config = lib.mkIf cfg.enable {
    # greetd for login
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
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
