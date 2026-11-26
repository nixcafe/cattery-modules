{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.operations.cloud.openstack;
in
{
  options.${namespace}.cli-apps.operations.cloud.openstack = {
    enable = lib.mkEnableOption "openstack";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      openstackclient
    ];

    # OpenStack clouds.yaml, secure.yaml, and cached tokens.
    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      xdg.config.directories = [
        "openstack"
      ];
    };
  };
}
