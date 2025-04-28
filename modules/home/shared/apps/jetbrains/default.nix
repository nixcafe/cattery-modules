{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.apps.jetbrains;
in
{
  options.${namespace}.apps.jetbrains = {
    enable = lib.mkEnableOption "jetbrains";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      ## jetbrains ide
      jetbrains.webstorm
      jetbrains.rust-rover
      jetbrains.ruby-mine
      jetbrains.rider
      jetbrains.pycharm-professional
      jetbrains.phpstorm
      jetbrains.idea-ultimate
      jetbrains.goland
      jetbrains.dataspell
      jetbrains.datagrip
      jetbrains.clion
    ];

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      xdg = {
        cache.directories = [
          "JetBrains"
        ];
        data.directories = [
          "JetBrains"
        ];
        config.directories = [
          "JetBrains"
        ];
      };
      directories = [ ".java/.userPrefs/jetbrains" ];
    };

  };

}
