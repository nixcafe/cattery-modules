{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    mkPackageOption
    types
    ;

  cfg = config.${namespace}.cli-apps.tool.tea;
in
{
  options.${namespace}.cli-apps.tool.tea = with types; {
    enable = mkEnableOption "tea";
    package = mkPackageOption pkgs "tea" { };
    gitCredentialHelper = {
      enable = mkEnableOption "the tea git credential helper" // {
        default = true;
      };
      hosts = mkOption {
        type = listOf str;
        default = [ "https://gitea.com" ];
        description = "Gitea hosts to enable the tea git credential helper for";
        example = [
          "https://gitea.com"
          "https://gitea.example.com"
        ];
      };
    };
    persistence = mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    programs.git.settings.credential = lib.mkIf cfg.gitCredentialHelper.enable (
      builtins.listToAttrs (
        map (
          host:
          lib.nameValuePair host {
            helper = [
              ""
              "${cfg.package}/bin/tea login helper"
            ];
          }
        ) cfg.gitCredentialHelper.hosts
      )
    );

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      xdg.config.directories = [
        "tea"
      ];
    };
  };

}
