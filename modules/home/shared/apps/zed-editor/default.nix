{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;
  inherit (config.${namespace}.user) settings;

  jsonFormat = pkgs.formats.json { };
  jsonType = jsonFormat.type;

  cfg = config.${namespace}.apps.zed-editor;
in
{
  options.${namespace}.apps.zed-editor = with types; {
    enable = lib.mkEnableOption "zed-editor";
    userSettings = mkOption {
      type = jsonType;
      default = settings.zed-editor.userSettings or { };
    };
    userKeymaps = mkOption {
      type = jsonType;
      default = settings.zed-editor.userKeymaps or { };
    };
    extensions = mkOption {
      type = listOf str;
      default = settings.zed-editor.extensions or [ ];
      description = "https://github.com/zed-industries/extensions/tree/main/extensions";
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
      type = attrs;
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
        extensions
        installRemoteServer
        ;
    } // cfg.extraOptions;

    home.sessionVariables = lib.mkIf cfg.defaultEditor {
      EDITOR = "zeditor --new --wait";
      VISUAL = "$EDITOR";
    };

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      xdg = {
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
