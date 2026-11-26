{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.operations.cloud.hetzner;
in
{
  options.${namespace}.cli-apps.operations.cloud.hetzner = {
    enable = lib.mkEnableOption "hetzner";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      hcloud
    ];

    # hcloud keeps its active context and tokens in ~/.config/hcloud/cli.toml.
    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      xdg.config.directories = [
        "hcloud"
      ];
    };
  };
}
