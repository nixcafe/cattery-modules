{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib) mkDefault;
  inherit (lib.${namespace}) mkDefaultEnabled;

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

    ${namespace}.desktop.hyprland = {
      enable = mkDefault true;
      theme.charm-cat = {
        convention = mkDefaultEnabled;
        fcitx = mkDefaultEnabled;
        file-manager = mkDefaultEnabled;
        launcher = mkDefaultEnabled;
        lock-screen = mkDefaultEnabled;
        notification = mkDefaultEnabled;
        screenshots = mkDefaultEnabled;
        terminal = mkDefaultEnabled;
        vscode = mkDefaultEnabled;
        waybar = mkDefaultEnabled;
        wlogout = mkDefaultEnabled;
      };
    };
  };
}
