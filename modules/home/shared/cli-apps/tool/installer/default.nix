{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.tool.installer;
in
{
  options.${namespace}.cli-apps.tool.installer = {
    enable = lib.mkEnableOption "installer";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      disko
      colmena
      nixos-anywhere
      deploy-rs
    ];
  };

}
