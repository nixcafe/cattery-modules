{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib) optionalAttrs;
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  cfg = config.${namespace}.apps.winbox;
in
{
  options.${namespace}.apps.winbox = {
    enable = lib.mkEnableOption "winbox";
    package = lib.mkPackageOption pkgs "winbox" { };
    openFirewall = lib.mkOption {
      description = ''
        Whether to open ports for the MikroTik Neighbor Discovery protocol. Required for Winbox neighbor discovery.
        (Only Linux)
      '';
      default = false;
      type = lib.types.bool;
    };
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
    ];

    programs = optionalAttrs isLinux {
      winbox = {
        inherit (cfg) package openFirewall;

        enable = true;
      };
    };

    ${namespace}.home.extraOptions = {
      ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
        xdg = {
          data.directories = [
            "MikroTik"
          ];
        };
      };
    };

  };

}
