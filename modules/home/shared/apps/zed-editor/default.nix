{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types literalExpression;
  inherit (config.${namespace}.user) settings;

  jsonFormat = pkgs.formats.json { };
  jsonType = jsonFormat.type;

  cfg = config.${namespace}.apps.zed-editor;
in
{
  options.${namespace}.apps.zed-editor = {
    enable = lib.mkEnableOption "zed-editor";
    package = lib.mkPackageOption pkgs "zed-editor" { nullable = true; };
    extraPackages = mkOption {
      type = with types; listOf package;
      default = [ ];
      example = literalExpression "[ pkgs.nixd ]";
      description = "Extra packages available to Zed.";
    };
    userSettings = mkOption {
      type = jsonType;
      default = settings.zed-editor.userSettings or { };
    };
    userKeymaps = mkOption {
      type = jsonType;
      default = settings.zed-editor.userKeymaps or [ ];
    };
    userTasks = mkOption {
      inherit (jsonFormat) type;
      default = settings.zed-editor.userTasks or [ ];
      example = literalExpression ''
        [
          {
            label = "Format Code";
            command = "nix";
            args = [ "fmt" "$ZED_WORKTREE_ROOT" ];
          }
        ]
      '';
      description = ''
        Configuration written to Zed's {file}`tasks.json`.

        [List of tasks](https://zed.dev/docs/tasks) that can be run from the
        command palette.
      '';
    };
    extensions = mkOption {
      type = with types; listOf str;
      default = settings.zed-editor.extensions or [ ];
      description = "https://github.com/zed-industries/extensions/tree/main/extensions";
    };
    mutableUserTasks = mkOption {
      type = types.bool;
      default = true;
      example = false;
      description = ''
        Whether user tasks (tasks.json) can be updated by zed.
      '';
    };
    installRemoteServer = lib.mkEnableOption ''
      Whether to symlink the Zed's remote server binary to the expected
      location. This allows remotely connecting to this system from a
      distant Zed client.

      For more information, consult the
      ["Remote Server" section](https://wiki.nixos.org/wiki/Zed#Remote_Server)
      in the wiki.
    '';
    defaultEditor = lib.mkEnableOption "zed-editor to $EDITOR";
    extraOptions = mkOption {
      type = with types; attrs;
      default = { };
    };
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zed-editor = {
      inherit (cfg)
        enable
        userSettings
        userKeymaps
        userTasks
        extensions
        installRemoteServer
        extraPackages
        mutableUserTasks
        ;
    }
    // cfg.extraOptions;

    home.sessionVariables = lib.mkIf cfg.defaultEditor {
      EDITOR = "zeditor --new --wait";
      VISUAL = "$EDITOR";
    };

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      xdg = {
        cache.directories = [
          "zed"
        ];
        data.directories = [
          "zed"
        ];
        config.directories = [
          "zed"
        ];
      };
    };
  };

}
