{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.operations.cloud.linode;
in
{
  options.${namespace}.cli-apps.operations.cloud.linode = {
    enable = lib.mkEnableOption "linode";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      linode-cli
    ];

    # linode-cli stores profiles and API tokens in ~/.config/linode-cli.
    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      xdg.config.files = [
        "linode-cli"
      ];
    };
  };
}
