{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.tool.lark-cli;
in
{
  options.${namespace}.cli-apps.tool.lark-cli = {
    enable = lib.mkEnableOption "lark-cli";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      lark-cli
    ];

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      directories = [
        ".lark-cli"
      ];
    };
  };

}
