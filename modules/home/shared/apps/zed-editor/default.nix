{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.apps.zed-editor;
in
{
  options.${namespace}.apps.zed-editor = with types; {
    enable = lib.mkEnableOption "zed-editor";
    installRemoteServer = lib.mkEnableOption ''
      Whether to symlink the Zed's remote server binary to the expected
      location. This allows remotely connecting to this system from a
      distant Zed client.

      For more information, consult the
      ["Remote Server" section](https://wiki.nixos.org/wiki/Zed#Remote_Server)
      in the wiki.
    '';
    defaultEditor = lib.mkEnableOption "zed-editor to $EDITOR";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
    extraOptions = mkOption {
      type = attrs;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zed-editor = {
      inherit (cfg) enable installRemoteServer;
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
