{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  cfg = config.${namespace}.system.boot.lanzaboote;
in
{
  options.${namespace}.system.boot.lanzaboote = {
    enable = lib.mkEnableOption "boot lanzaboote";
    pkiBundle = lib.mkOption {
      type = lib.types.nullOr lib.types.externalPath;
      description = "PKI bundle containing db, PK, KEK";
      default = "/var/lib/sbctl";
    };
    extraOptions = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      # For debugging and troubleshooting Secure Boot.
      pkgs.sbctl
    ];

    # Lanzaboote currently replaces the systemd-boot module.
    # This setting is usually set to true in configuration.nix
    # generated at installation time. So we force it to false
    # for now.
    boot.loader.systemd-boot.enable = lib.mkForce false;

    boot.lanzaboote = {
      inherit (cfg) pkiBundle;

      enable = true;
    }
    // cfg.extraOptions;
  };

}
