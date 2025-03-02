{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.services.openssh;
in
{
  options.${namespace}.services.openssh = {
    enable = lib.mkEnableOption "openssh";
  };

  config = {
    services.openssh = {
      # enable openssh
      enable = lib.mkDefault cfg.enable;
    };
  };
}
