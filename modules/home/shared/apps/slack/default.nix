{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.apps.slack;
in
{
  options.${namespace}.apps.slack = {
    enable = lib.mkEnableOption "slack";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      slack
    ];

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      xdg = {
        config.directories = [
          "Slack"
        ];
      };
    };

  };

}
