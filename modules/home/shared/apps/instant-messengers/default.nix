{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.apps.instant-messengers;
in
{
  options.${namespace}.apps.instant-messengers = {
    enable = lib.mkEnableOption "instant messengers";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      telegram-desktop
      vesktop # replace discord
    ];

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      xdg.data.directories = [
        "TelegramDesktop"
      ];
      xdg.config.directories = [
        "vesktop"
      ];
    };
  };
}
