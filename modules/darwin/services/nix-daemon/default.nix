{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.services.nix-daemon;
in
{
  options.${namespace}.services.nix-daemon = {
    enable = lib.mkEnableOption "nix daemon";
  };

  config = lib.mkIf cfg.enable {
    # auto upgrade nix package and the daemon service
    services.nix-daemon.enable = true;
  };
}
