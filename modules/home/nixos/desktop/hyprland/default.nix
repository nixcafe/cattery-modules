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

  callbackModule = types.submodule (
    { name, config, ... }:
    {
      options = {
        name = mkOption {
          type = types.str;
          default = name;
          description = "Name of the Hyprland event this callback responds to.";
        };
        execs = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = ''
            A list of Lua expressions executed through `hl.exec_cmd` when the event
            is triggered.

            Event arguments can be accessed with `args[1]`, `args[2]`, etc.

            Example:

              "notify-send 'workspace: '..args[1]"
          '';
        };
        callbacks = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "Lua callback expressions to execute on this event.";
        };
        execFunc = mkOption {
          readOnly = true;
          type = types.str;
          description = "Generated Lua function wrapping hl.exec_cmd calls for this event.";
          default = ''
            function(...)
              local arg = {...}

              ${concatStringsSep "\n  " (map (exec: "hl.exec_cmd(" + exec + ")") config.execs)}
            end'';
        };
      };
    }
  );

  cfg = config.${namespace}.desktop.hyprland;
in
{
  options.${namespace}.desktop.hyprland = {
    enable = lib.mkEnableOption "hyprland";
    require = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = "List of Hyprland config module paths to require.";
    };
    on = mkOption {
      default = { };
      type = types.attrsOf callbackModule;
      description = "Hyprland event callbacks keyed by event name.";
    };
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    wayland.windowManager.hyprland = {
      enable = true;
      # enable hyprland-session.target on hyprland startup.
      systemd.enable = true;

      extraConfig = ''
        ${concatStringsSep "\n" (map (path: "require(\"" + path + "\")") cfg.require)}
      '';

      settings = {
        on = lib.concatMap (
          f:
          (lib.optionals (f.execs != [ ]) [
            {
              _args = [
                f.name
                (lib.generators.mkLuaInline f.execFunc)
              ];
            }
          ])
          ++ (map (callback: {
            _args = [
              f.name
              (lib.generators.mkLuaInline callback)
            ];
          }) f.callbacks)
        ) (builtins.attrValues cfg.on);
      };
    };
  };

}
