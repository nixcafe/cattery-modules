{
  config,
  lib,
  namespace,
  inputs,
  purr,
  ...
}:
let
  inherit (purr.meta) isLinux isDarwin;

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
      // (lib.optionalAttrs isLinux {
        persistent = true;
        dates = "monthly";
        randomizedDelaySec = "45min";
      })
      // (lib.optionalAttrs isDarwin {
        interval = {
          Weekday = 1;
          Hour = 4;
          Minute = 0;
        };
      });
    };
  };

}
