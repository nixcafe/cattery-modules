{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}.module) mkDefaultEnabled;

  cfg = config.${namespace}.room.server;
in
{
  options.${namespace}.room.server-mini = {
    enable = lib.mkEnableOption "room server-mini";
  };

  config = lib.mkIf cfg.enable {
    ${namespace} = {
      room.basis = mkDefaultEnabled;
      system.impermanence.xdg.userDirs.enable = lib.mkDefault false;

      cli-apps = {
        shell = {
          starship = mkDefaultEnabled;
        };
      };
    };
  };
}
