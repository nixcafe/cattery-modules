{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optional
    optionalAttrs
    types
    ;

  cfg = config.${namespace}.services.firecracker;
in
{
  options.${namespace}.services.firecracker = with types; {
    enable = mkEnableOption "Firecracker microVM support";
    package = mkPackageOption pkgs "firecracker" { };
    extraPackages = mkOption {
      type = listOf package;
      default = [ pkgs.firectl ];
      description = ''
        Extra packages installed for managing Firecracker microVMs.
        `firectl` is included by default as a convenient launcher.
      '';
    };
    user = mkOption {
      type = str;
      default = "firecracker";
      description = "System user used for Firecracker state and tooling.";
    };
    group = mkOption {
      type = str;
      default = "firecracker";
      description = "System group used for Firecracker state and tooling.";
    };
    stateDir = mkOption {
      type = path;
      default = "/var/lib/firecracker";
      description = "Directory for Firecracker VM images, kernels, and runtime state.";
    };
    enableKVM = mkOption {
      type = bool;
      default = true;
      description = ''
        Load the KVM kernel modules, create the `kvm` group, and add the
        Firecracker user to it. Disable this when the host already manages
        `/dev/kvm` or when running inside a guest without nested virtualization.
      '';
    };
    kernelModules = mkOption {
      type = listOf str;
      default = [ "kvm" ];
      description = ''
        Kernel modules to load for Firecracker. On x86_64 hosts you may need
        to add `kvm_intel` or `kvm_amd` explicitly, depending on the CPU.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ] ++ cfg.extraPackages;

    boot.kernelModules = mkIf cfg.enableKVM cfg.kernelModules;

    users.groups = {
      ${cfg.group} = { };
    }
    // optionalAttrs cfg.enableKVM {
      kvm = { };
    };

    users.users.${cfg.user} = {
      isSystemUser = true;
      inherit (cfg) group;
      home = cfg.stateDir;
      createHome = false;
      extraGroups = optional cfg.enableKVM "kvm";
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.stateDir} 0750 ${cfg.user} ${cfg.group} -"
    ];
  };
}
