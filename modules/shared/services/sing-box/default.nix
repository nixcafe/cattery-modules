{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  cfg = config.${namespace}.services.sing-box;
  settingsFormat = pkgs.formats.json { };

  secretConfigScript = pkgs.writeShellScript "sing-box-secret-config" ''
    if [ -f "/etc/sing-box/config.json" ]; then
      cp -f /etc/sing-box/config.json /run/sing-box/config.json
    fi
  '';
in
{
  options.${namespace}.services.sing-box = {
    enable = lib.mkEnableOption "sing-box";
    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
      };
      default = { };
      description = ''
        The sing-box configuration, see <https://sing-box.sagernet.org/configuration/> for documentation.

        Options containing secret data should be set to an attribute set
        containing the attribute `_secret` - a string pointing to a file
        containing the value the option should be set to.
      '';
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      (lib.optionalAttrs isLinux {
        # enable sing-box
        services.sing-box = {
          inherit (cfg) settings;
          enable = true;
        };
        systemd.services.sing-box = {
          # use own config
          serviceConfig = {
            ExecStartPre = lib.mkAfter [
              "+${secretConfigScript}"
            ];
          };
        };
      })
    ]
  );
}
