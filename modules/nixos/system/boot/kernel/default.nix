{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types optionalAttrs;

  cfg = config.${namespace}.system.boot.kernel;
in
{
  options.${namespace}.system.boot.kernel = with types; {
    enable = lib.mkEnableOption "kernel";
    version = mkOption {
      type = str;
      default = "latest";
      description = "Linux kernel version to use (e.g. 'latest', '6.12', '6.6').";
    };
    sysctl = mkOption {
      type = attrs;
      default = { };
      description = "Kernel sysctl parameters to set (e.g. 'net.ipv4.ip_forward').";
    };
    useIpForward = lib.mkEnableOption "IP forwarding";
  };

  config = lib.mkIf cfg.enable {
    boot.kernelPackages =
      if cfg.version == "latest" then
        pkgs.linuxPackages_latest
      else
        pkgs.linuxKernel.packages."linux_${builtins.replaceStrings [ "." ] [ "_" ] cfg.version}";
    boot.zfs = lib.mkIf (cfg.version == "latest") {
      package = pkgs.zfs_unstable;
    };

    boot.kernel.sysctl =
      (optionalAttrs cfg.useIpForward {
        "net.ipv4.ip_forward" = 1;
      })
      // cfg.sysctl;
  };
}
