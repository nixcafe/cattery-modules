{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;

  cfg = config.${namespace}.apps.instant-messengers;
in
{
  config = lib.mkIf (cfg.enable && isLinux) {
    home.packages = with pkgs; [
      signal-desktop
      element-desktop
    ];

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      xdg.config.directories = [
        "Signal"
        "Element"
      ];
    };
  };
}
