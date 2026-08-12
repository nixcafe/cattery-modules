{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption optionalAttrs types;

  cfg = config.${namespace}.system.boot.kernel;

  # Whether the ZFS kernel module for the given vanilla kernel name is not broken.
  supportsZfs =
    zfsAttr: name:
    let
      r = builtins.tryEval (
        let
          k = pkgs.linuxKernel.packages.${name};
        in
        k.${zfsAttr}.meta.broken
      );
    in
    r.success && r.value == false;

  # Major.minor versions of all vanilla kernels whose ZFS module builds.
  zfsCompatibleKernelVersions =
    let
      zfsAttr = pkgs.zfs.kernelModuleAttribute;
      # Only the vanilla `linux_X_Y` kernels, skip hardened/zen/rt/rpi variants.
      vanillaKernels = builtins.filter (n: builtins.match "linux_[0-9]+_[0-9]+" n != null) (
        builtins.attrNames pkgs.linuxKernel.packages
      );
    in
    builtins.map (n: lib.versions.majorMinor pkgs.linuxKernel.packages.${n}.kernel.version) (
      builtins.filter (supportsZfs zfsAttr) vanillaKernels
    );

  # The newest vanilla kernel version (major.minor) that can build the ZFS
  # kernel module. Re-evaluates automatically on every nixpkgs bump.
  latestZfsCompatibleVersion =
    let
      versions = zfsCompatibleKernelVersions;
    in
    if versions == [ ] then
      builtins.throw "No kernel in nixpkgs is compatible with the current ZFS version"
    else
      lib.lists.last (lib.sort lib.versionOlder versions);

  # The linuxPackages set for the newest ZFS-compatible kernel.
  latestZfsCompatibleKernel =
    pkgs.linuxKernel.packages."linux_${
      builtins.replaceStrings [ "." ] [ "_" ] latestZfsCompatibleVersion
    }";

  kernelPackages =
    if cfg.useLatestZfsCompatible then
      latestZfsCompatibleKernel
    else if cfg.version != null then
      pkgs.linuxKernel.packages."linux_${builtins.replaceStrings [ "." ] [ "_" ] cfg.version}"
    else
      pkgs.linuxPackages_latest;
in
{
  options.${namespace}.system.boot.kernel = with types; {
    # Pick the kernel to boot: latest by default, or an explicit version.
    useLatest = lib.mkEnableOption "the latest Linux kernel";
    version = mkOption {
      type = nullOr str;
      default = null;
      description = ''
        Explicit Linux kernel version to use (e.g. '6.12', '6.6').
        Takes precedence over `useLatest`. Ignored when
        `useLatestZfsCompatible` is enabled.
      '';
    };
    useLatestZfsCompatible = lib.mkEnableOption "the newest vanilla kernel whose ZFS module builds";
    sysctl = mkOption {
      type = attrs;
      default = { };
      description = "Kernel sysctl parameters to set (e.g. 'net.ipv4.ip_forward').";
    };
    useIpForward = lib.mkEnableOption "IP forwarding";
  };

  config = lib.mkIf (cfg.useLatest || cfg.useLatestZfsCompatible || cfg.version != null) {
    boot.kernelPackages = kernelPackages;

    boot.zfs = lib.mkIf (cfg.useLatest || cfg.useLatestZfsCompatible) {
      package = if cfg.useLatestZfsCompatible then pkgs.zfs else pkgs.zfs_unstable;
    };

    boot.kernel.sysctl =
      (optionalAttrs cfg.useIpForward {
        "net.ipv4.ip_forward" = 1;
      })
      // cfg.sysctl;

    assertions = [
      {
        assertion = !(cfg.useLatestZfsCompatible && cfg.version != null);
        message = "cattery.system.boot.kernel: `useLatestZfsCompatible` and an explicit `version` are mutually exclusive; pick one";
      }
    ];
  };
}
