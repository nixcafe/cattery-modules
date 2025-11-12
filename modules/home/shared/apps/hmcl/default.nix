{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.apps.hmcl;
in
{
  options.${namespace}.apps.hmcl = {
    enable = lib.mkEnableOption "hmcl";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      hmcl
    ];

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      xdg = {
        data.directories = [
          "hmcl"
        ];
      };
      directories = [
        ".hmcl"
        ".minecraft"
      ];
    };

  };

}
