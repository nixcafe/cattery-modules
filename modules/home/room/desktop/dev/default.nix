{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkDefault;
  inherit (lib.${namespace}) mkDefaultEnabled;

  cfg = config.${namespace}.room.desktop.dev;
in
{
  options.${namespace}.room.desktop.dev = {
    enable = lib.mkEnableOption "room desktop dev";
    allDevKit = lib.mkEnableOption "enable all dev-kit apps";
  };

  config = lib.mkIf cfg.enable {
    ${namespace} = {
      room.desktop.general = mkDefaultEnabled;

      apps = {
        instant-messengers = mkDefaultEnabled;
        jetbrains = mkDefaultEnabled;
        code-cursor = mkDefaultEnabled;
      };
      cli-apps = {

        database = {
          postgresql = mkDefaultEnabled;
          sqlite = mkDefaultEnabled;
        };

        dev-kit = lib.mkIf cfg.allDevKit {
          cpp = mkDefaultEnabled;
          dive = mkDefaultEnabled;
          go = mkDefaultEnabled;
          java = {
            enable = mkDefault true;
            maven = mkDefaultEnabled;
            gradle = mkDefaultEnabled;
          };
          javascript = mkDefaultEnabled;
          lua = mkDefaultEnabled;
          rust = mkDefaultEnabled;
          wasm = mkDefaultEnabled;
        };

        operations = {
          cloud = mkDefaultEnabled;
          kubernetes = mkDefaultEnabled;
        };

        security = {
          gnupg = mkDefaultEnabled;
        };

        tool = {
          ollama = mkDefaultEnabled;
          thefuck = mkDefaultEnabled;
        };

        video = {
          visual = mkDefaultEnabled;
          youtube = mkDefaultEnabled;
        };
      };

      # linux config
      apps = {
        thunderbird = mkDefaultEnabled;
        science = mkDefaultEnabled;
        video = mkDefaultEnabled;
      };
      cli-apps = {
        cloudflared = mkDefaultEnabled;
        warp = mkDefaultEnabled;
      };

      # darwin config
      apps = {
        iina = mkDefaultEnabled;
      };
      cli-apps = {
        android = mkDefaultEnabled;
      };

    };
  };
}
