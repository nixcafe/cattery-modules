{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.shared.cli-apps.security.gnupg;
in
{
  options.${namespace}.shared.cli-apps.security.gnupg = {
    enable = lib.mkEnableOption "gnupg";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ gnupg ];
  };

}
