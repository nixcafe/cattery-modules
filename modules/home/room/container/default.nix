{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}.module) mkDefaultEnabled;

  cfg = config.${namespace}.room.container;
in
{
  options.${namespace}.room.container = {
    enable = lib.mkEnableOption "room container";
  };

  config = lib.mkIf cfg.enable {
    ${namespace} = {
      room.basis = mkDefaultEnabled;

      cli-apps = {
        shell = {
          starship = mkDefaultEnabled;
        };

        tool = {
          acme-sh = mkDefaultEnabled;
        };
      };
    };
  };
}
