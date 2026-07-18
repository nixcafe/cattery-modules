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

      services = {
        acme = mkDefaultEnabled;
      };
    };

    boot.isContainer = true;
  };
}
