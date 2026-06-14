{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    concatStringsSep
    ;

  inherit (pkgs.stdenv.hostPlatform) isLinux;

  cfg = config.${namespace}.desktop.niri;

  renderBinds =
    binds:
    let
      renderBind =
        key: action:
        if builtins.isString action then
          "${key} { ${action}; }"
        else if builtins.isList action then
          "${key} { ${concatStringsSep "; " action}; }"
        else
          throw "niri bind action must be a string or list of strings";
    in
    concatStringsSep "\n" (map (key: renderBind key binds.${key}) (builtins.attrNames binds));

  renderInclude = paths: concatStringsSep "\n" (map (path: ''include "${path}"'') paths);

  renderSpawn = cmds: concatStringsSep "\n" (map (cmd: ''spawn-at-startup "${cmd}"'') cmds);

  generatedConfig =
    let
      includeSection = renderInclude cfg.include;
      bindsSection =
        if cfg.binds != { } then
          ''
            binds {
            ${renderBinds cfg.binds}
            }
          ''
        else
          "";
      spawnSection = renderSpawn cfg.spawnAtStartup;
    in
    ''
      ${if cfg.configText != "" then cfg.configText else ""}
      ${includeSection}
      ${spawnSection}
      ${bindsSection}
    '';
in
{
  options.${namespace}.desktop.niri = {
    enable = lib.mkEnableOption "niri";

    configText = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Raw KDL configuration for niri (contents of config.kdl).
        Appended before structured options like include, binds and spawnAtStartup.
      '';
    };

    include = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [
        "colors.kdl"
        "binds.kdl"
        "window-rules.kdl"
      ];
      description = ''
        KDL files to include at the top level of the config.
        Paths are relative to ~/.config/niri/ (same directory as config.kdl).

        Each file can be deployed via xdg.configFile."niri/<name>.kdl"
        in your sub-modules, then add "<name>.kdl" here to enable it.

        This works like hyprland's `require` — sub-modules write their config
        files and register them here as a toggle switch.
      '';
    };

    binds = mkOption {
      type = types.attrsOf (types.either types.str (types.listOf types.str));
      default = { };
      example = {
        "Mod+Q" = "close-window";
        "Mod+T" = [
          "spawn"
          "kitty"
        ];
      };
      description = ''
        Keybindings rendered into a `binds { ... }` block.
        Each value can be a single action string or a list of actions.
      '';
    };

    spawnAtStartup = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [
        "waybar"
        "swaybg -i /path/to/wallpaper"
      ];
      description = "Commands to run at niri startup via spawn-at-startup.";
    };
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    home.packages = [ pkgs.niri ];

    xdg.configFile."niri/config.kdl".text = generatedConfig;
  };
}
