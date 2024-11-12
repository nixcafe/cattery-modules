{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.services.tailscale;
in
{
  options.${namespace}.services.tailscale = with types; {
    enable = lib.mkEnableOption "tailscale";
    extraOptions = mkOption {
      type = attrs;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    services.tailscale = {
      enable = true;
    } // cfg.extraOptions;

    ${namespace}.home.extraOptions = {
      home.packages = with pkgs; [
        # network
        tailscale
      ];
    };
  };

}
