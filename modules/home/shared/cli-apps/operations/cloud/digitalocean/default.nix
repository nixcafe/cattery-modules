{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.operations.cloud.digitalocean;
in
{
  options.${namespace}.cli-apps.operations.cloud.digitalocean = {
    enable = lib.mkEnableOption "digitalocean";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      doctl
    ];

    # doctl stores its config and access tokens under ~/.config/doctl.
    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      xdg.config.directories = [
        "doctl"
      ];
    };
  };
}
