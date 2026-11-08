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
    types
    ;

  cfg = config.${namespace}.services.containerd;
in
{
  options.${namespace}.services.containerd = with types; {
    enable = mkEnableOption "containerd container runtime";
    settings = mkOption {
      type = attrs;
      default = { };
      description = ''
        containerd configuration merged into `virtualisation.containerd.settings`.
        See https://github.com/containerd/containerd/blob/main/docs/man/containerd-config.toml.5.md
      '';
    };
    extraPackages = mkOption {
      type = listOf package;
      default = with pkgs; [
        cni-plugins
        nerdctl
        buildkit
      ];
      description = ''
        Command-line tools installed alongside containerd.
        `nerdctl` and `buildkit` are useful for building and running OCI
        workloads without Docker; `cni-plugins` provides the standard CNI
        plugins.
      '';
    };
    extraOptions = mkOption {
      type = attrs;
      default = { };
      description = "Extra virtualisation.containerd NixOS options merged at top level.";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.containerd = {
      enable = true;
      inherit (cfg) settings;
    }
    // cfg.extraOptions;

    environment.systemPackages = cfg.extraPackages;
  };
}
