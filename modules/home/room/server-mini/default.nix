{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkDefaultEnabled;

  cfg = config.${namespace}.room.server;
in
{
  options.${namespace}.room.server-mini = {
    enable = lib.mkEnableOption "room server-mini";
  };

  config = lib.mkIf cfg.enable {
    ${namespace} = {
      room.basis = mkDefaultEnabled;

      cli-apps = {
        shell = {
          starship = mkDefaultEnabled;
          nushell = mkDefaultEnabled;
        };
      };
    };
  };
}
