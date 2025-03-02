{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkDefaultEnabled;

  cfg = config.${namespace}.desktop.plasma;
in
{
  options.${namespace}.desktop.plasma = {
    enable = lib.mkEnableOption "plasma";
    useConnect = lib.mkEnableOption "kdeconnect";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    ${namespace} = {
      desktop.addons.xdg-portal = mkDefaultEnabled;

      home.extraOptions = {
        home.packages = with pkgs; [ kwalletcli ];

        ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
          xdg.data.directories = [ "kwalletd" ];
        };
      };
    };

    programs.kdeconnect.enable = cfg.useConnect;

    # sddm for login
    services.displayManager.sddm = {
      enable = true;
      autoNumlock = true;
      wayland.enable = true;
    };

    # plasma6
    services.desktopManager.plasma6.enable = true;
  };

}
