{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.services.openssh;
in
{
  options.${namespace}.services.openssh = with types; {
    enable = lib.mkEnableOption "openssh";
    settings = mkOption {
      type = attrs;
      default = { };
    };
    extraOptions = mkOption {
      type = attrs;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    services.openssh = {
      inherit (cfg) settings;

      # enable openssh
      enable = true;
    }
    // cfg.extraOptions;
  };

}
