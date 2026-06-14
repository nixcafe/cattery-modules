{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  cfg = config.${namespace}.apps.game.steam;
in
{
  options.${namespace}.apps.game.steam = {
    enable = lib.mkEnableOption "steam";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      protonup-qt
    ];

    # the app that maximizes my retention
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };
    hardware.steam-hardware.enable = true;

    ${namespace}.home.extraOptions = {
      ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
        # Steam Proton/Wine prefix (game data) path:
        # ~/.steam/steam/steamapps/compatdata/<AppID>/pfx/drive_c/
        # Example: Portal 2 (AppID 620) https://store.steampowered.com/app/620/Portal_2/
        directories = [
          ".steam"
        ];
        xdg.data.directories = [
          "Steam"
          "vulkan"
        ];
      };
    };
  };

}
