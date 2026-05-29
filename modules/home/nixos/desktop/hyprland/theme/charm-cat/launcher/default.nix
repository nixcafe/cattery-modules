{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  cfg = config.${namespace}.desktop.hyprland.theme.charm-cat.launcher;

  anyrunPlugins = with pkgs; [
    "${anyrun}/lib/libapplications.so"
    "${anyrun}/lib/libsymbols.so"
    "${anyrun}/lib/libshell.so"
    "${anyrun}/lib/librink.so"
    "${anyrun}/lib/libkidex.so"
    "${anyrun}/lib/libwebsearch.so"
  ];
in
{
  options.${namespace}.desktop.hyprland.theme.charm-cat.launcher = {
    enable = lib.mkEnableOption "charm-cat launcher";
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    programs.anyrun = {
      enable = true;

      config = {
        width = {
          fraction = 0.4;
        };
        y = {
          fraction = 0.3;
        };
        hideIcons = false;
        ignoreExclusiveZones = false;
        layer = "overlay";
        hidePluginInfo = true;
        closeOnClick = false;
        showResultsImmediately = false;
        maxEntries = null;
        plugins = anyrunPlugins;
      };

      extraCss = builtins.readFile ./conf/style.css;

      extraConfigFiles = {
        "applications.ron".text = builtins.readFile ./conf/applications.ron;
        "shell.ron".text = builtins.readFile ./conf/shell.ron;
        "websearch.ron".text = builtins.readFile ./conf/websearch.ron;
      };
    };

    ${namespace}.desktop.hyprland = {
      require = [
        "anyrun.anyrun"
      ];
    };

    xdg.configFile = {
      # preventing nix gc
      "hypr/anyrun" = {
        source = ./lua;
        recursive = true;
      };
    };
  };
}
