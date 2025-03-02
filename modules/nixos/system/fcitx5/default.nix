{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.system.fcitx5;
in
{
  options.${namespace}.system.fcitx5 = {
    enable = lib.mkEnableOption "fcitx5";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    # fcitx5
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          fcitx5-rime
          fcitx5-configtool
          fcitx5-chinese-addons
          fcitx5-gtk
        ];
      };
    };

    ${namespace}.home.extraOptions = {
      home.packages = with pkgs; [
        # cli stuff
        rime-cli
      ];

      ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
        xdg = {
          config.directories = [
            "fcitx5"
          ];
          data.directories = [
            "fcitx5"
          ];
        };
      };
    };
  };

}
