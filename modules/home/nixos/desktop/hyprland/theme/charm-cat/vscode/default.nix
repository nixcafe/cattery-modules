{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  cfg = config.${namespace}.desktop.hyprland.theme.charm-cat.vscode;
in
{
  options.${namespace}.desktop.hyprland.theme.charm-cat.vscode = {
    enable = lib.mkEnableOption "charm-cat vscode";
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    programs.vscode = {
      enable = true;
    };

    ${namespace}.desktop.hyprland = {
      require = [
        "vscode.code"
      ];
    };

    xdg.configFile = {
      # preventing nix gc
      "hypr/vscode" = {
        source = ./lua;
        recursive = true;
      };
    };
  };
}
