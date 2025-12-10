{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  cfg = config.${namespace}.apps.instant-messengers;
in
{
  config = lib.mkIf (cfg.enable && isLinux) {
    home.packages = with pkgs; [
      signal-desktop
      element-desktop
      feishu
    ];

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      directories = [
        # feishu
        ".bytertc"
      ];
      xdg.config.directories = [
        "Signal"
        "Element"
        # feishu
        "bytertc"
      ];
    };
  };
}
