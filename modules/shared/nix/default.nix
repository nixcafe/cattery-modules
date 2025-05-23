{
  pkgs,
  config,
  lib,
  namespace,
  inputs,
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
      optimise.automatic = isLinux;
      registry = {
        # use: `nix flake init -t beans#<name>`
        beans.flake = inputs.develop-templates;
      };
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
          dates = "months";
          randomizedDelaySec = "45min";
        })
        // (optionalAttrs isDarwin {
          interval = {
            Weekday = 1;
            Hour = 4;
            Minute = 0;
          };
        });
    };
  };

}
