{
  pkgs,
  config,
  lib,
  namespace,
  inputs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;
  inherit (lib) optionalAttrs;

  cfg = config.${namespace}.nix;
in
{
  options.${namespace}.nix = {
    enable = lib.mkEnableOption "nix";
  };

  config = lib.mkIf cfg.enable {
    nix = {
      optimise.automatic = isLinux;
      registry = {
        # use: `nix flake init -t beans#<name>`
        beans.flake = inputs.develop-templates;
      };
      settings = {
        # enable flakes support
        experimental-features = "nix-command flakes";
      };
      gc = {
        automatic = true;
        options = "--delete-older-than 30d";
      }
      // (optionalAttrs isLinux {
        persistent = true;
        dates = "monthly";
        randomizedDelaySec = "45min";
      })
      // (optionalAttrs isDarwin {
        # use Determinate Nix
        automatic = false;
        interval = {
          Weekday = 1;
          Hour = 4;
          Minute = 0;
        };
      });
    };
  };

}
