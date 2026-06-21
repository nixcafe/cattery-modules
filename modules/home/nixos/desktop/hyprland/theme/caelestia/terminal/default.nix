{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  cfg = config.${namespace}.desktop.hyprland.theme.caelestia.terminal;
in
{
  options.${namespace}.desktop.hyprland.theme.caelestia.terminal = {
    enable = lib.mkEnableOption "caelestia terminal";
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    programs.kitty = {
      enable = true;

      settings = {
        font_family = "JetBrains Mono Nerd Font";
        font_size = "12.0";
        bold_font = "auto";
        italic_font = "auto";
        bold_italic_font = "auto";

        cursor_shape = "beam";
        cursor_trail = "1";

        window_margin_width = "8";
        window_padding_width = "8";

        confirm_os_window_close = "0";

        scrollback_lines = "10000";
        scrollback_pager_history_size = "100";

        tab_bar_style = "fade";
        tab_bar_edge = "bottom";

        enable_audio_bell = "no";
        copy_on_select = "yes";
        strip_trailing_spaces = "smart";
        mouse_hide_wait = "2";
        background_opacity = "0.92";
      };

      keybindings = {
        "ctrl+c" = "copy_or_interrupt";
        "ctrl+shift+f" = "kitten hints";
        "page_up" = "scroll_page_up";
        "page_down" = "scroll_page_down";
        "ctrl+plus" = "change_font_size all +1";
        "ctrl+equal" = "change_font_size all +1";
        "ctrl+kp_add" = "change_font_size all +1";
        "ctrl+minus" = "change_font_size all -1";
        "ctrl+underscore" = "change_font_size all -1";
        "ctrl+kp_subtract" = "change_font_size all -1";
        "ctrl+0" = "change_font_size all 0";
        "ctrl+kp_0" = "change_font_size all 0";
      };
    };

    ${namespace}.desktop.hyprland = {
      require = [
        "terminal.kitty"
      ];
    };

    xdg.configFile = {
      "hypr/terminal" = {
        source = ./lua;
        recursive = true;
      };
    };
  };
}
