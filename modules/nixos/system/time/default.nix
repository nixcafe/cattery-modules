{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;
  inherit (config.${namespace}) user;

  cfg = config.${namespace}.system.time;
in
{
  options.${namespace}.system.time = with types; {
    enable = lib.mkEnableOption "time";
    timeZone = mkOption {
      type = str;
      default = user.settings.timeZone or "America/New_York";
      description = "The time zone to use for the system.";
    };
  };

  config = lib.mkIf cfg.enable {
    time.timeZone = cfg.timeZone;
  };

}
