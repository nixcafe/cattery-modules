{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  cfg = config.${namespace}.desktop.hyprland.theme.charm-cat.audio;
in
{
  options.${namespace}.desktop.hyprland.theme.charm-cat.audio = {
    enable = lib.mkEnableOption "charm-cat audio";
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    services.pipewire = {
      enable = true;
      wireplumber = {
        enable = true;
        configs = {
          "51-stream-follows-default" = {
            "policy-node" = {
              "move" = true;
            };
          };
        };
      };
    };

    home.packages = with pkgs; [
      pavucontrol
      playerctl
      brightnessctl
    ];

    ${namespace}.desktop.hyprland = {
      require = [
        "audio.bind"
        "audio.rules"
      ];
    };

    xdg.configFile = {
      "hypr/audio" = {
        source = ./lua;
        recursive = true;
      };
    };
  };
}
