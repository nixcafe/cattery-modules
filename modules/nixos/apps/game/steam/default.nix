{
  config,
  lib,
  namespace,
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
    # the app that maximizes my retention
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };
    hardware.steam-hardware.enable = true;

    ${namespace}.home.extraOptions = {
      ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
        directories = [
          {
            directory = ".steam";
            method = "symlink";
          }
        ];
        xdg.data.directories = [
          {
            directory = "Steam";
            method = "symlink";
          }
          "vulkan"
        ];
      };
    };
  };

}
