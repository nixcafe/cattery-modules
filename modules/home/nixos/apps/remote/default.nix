{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;

  cfg = config.${namespace}.apps.remote;
in
{
  options.${namespace}.apps.remote = {
    enable = lib.mkEnableOption "remote";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    home.packages = with pkgs; [
      # rustdesk
      rustdesk
      # kde
      kdePackages.krdc
      # gnome
      remmina
    ];

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      xdg = {
        cache.directories = [
          "remmina"
        ];
        config.directories = [
          "remmina"
        ];
        data.directories = [
          "remmina"
        ];
      };
    };
  };

}
