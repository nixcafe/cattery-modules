{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}.module) mkDefaultEnabled;

  cfg = config.${namespace}.room.server.nas;
in
{
  options.${namespace}.room.server.nas = {
    enable = lib.mkEnableOption "room server nas";
  };

  config = lib.mkIf cfg.enable {
    ${namespace} = {
      room.server = mkDefaultEnabled;

      cli-apps = {
        tool = {
          useful = mkDefaultEnabled;
        };
        disk = mkDefaultEnabled;
      };
    };
  };
}
