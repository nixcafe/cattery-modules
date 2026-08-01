{
  config,
  lib,
  namespace,
  modulesPath,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.system.proxmox.lxc;
in
{
  imports = [
    # proxmox lxc
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
  ];

  options.${namespace}.system.proxmox.lxc = {
    enable = lib.mkEnableOption "proxmox lxc";
    manageNetwork = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to let Proxmox manage the network configuration.
      '';
    };
    manageHostName = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to let Proxmox manage the hostname.
      '';
    };
  };

  config = {
    # lxc config
    proxmoxLXC = {
      inherit (cfg) enable manageNetwork manageHostName;
    };

    # The `proxmox-lxc` image variant (`system.build.images.proxmox-lxc`)
    # inherits the `proxmoxLXC.enable = false` definition above, which would
    # disable it. Only force it on when the feature is not enabled on the
    # host, so an LXC image can still be built for image-only hosts.
    image.modules.proxmox-lxc = {
      proxmoxLXC.enable = lib.mkIf (!cfg.enable) (lib.mkForce true);
    };
  };

}
