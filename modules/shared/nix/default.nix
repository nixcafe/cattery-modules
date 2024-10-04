{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux isDarwin;
  inherit (lib) optionalAttrs;

  cfg = config.${namespace}.nix;
in
{
  options.${namespace}.nix = {
    enable = lib.mkEnableOption "nix";
  };

  config = lib.mkIf cfg.enable {
    nix = {
      settings = {
        # enable flakes support
        experimental-features = "nix-command flakes";
      };
      gc =
        {
          automatic = true;
          options = "--delete-older-than 30d";
        }
        // (optionalAttrs isLinux {
          persistent = true;
          dates = "0/4:0"; # expands to "*-*-* 00/04:00:00"
          randomizedDelaySec = "45min";
        })
        // (optionalAttrs isDarwin {
          user = "root";
          interval = {
            Weekday = 0;
            Hour = 4;
            Minute = 0;
          };
        });
    };
  };

}
