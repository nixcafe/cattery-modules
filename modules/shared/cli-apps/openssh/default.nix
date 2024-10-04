{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.openssh;
in
{
  options.${namespace}.cli-apps.openssh = {
    enable = lib.mkEnableOption "openssh";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      openssh
    ];
  };

}
