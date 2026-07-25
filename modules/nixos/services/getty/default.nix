{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.services.getty;
in
{
  options.${namespace}.services.getty = with types; {
    enable = lib.mkEnableOption "getty";
    autologinUser = mkOption {
      type = types.nullOr types.str;
      default = config.${namespace}.user.name;
      description = "Username to automatically log in on the console.";
    };
    extraOptions = mkOption {
      type = attrs;
      default = { };
      description = "Extra services.getty NixOS options merged at top level.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.getty = {
      inherit (cfg) autologinUser;
    }
    // cfg.extraOptions;
  };

}
