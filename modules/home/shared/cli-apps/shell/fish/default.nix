{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (config.${namespace}.user) defaultUserShell;

  cfg = config.${namespace}.cli-apps.shell.fish;
in
{
  options.${namespace}.cli-apps.shell.fish = {
    enable = lib.mkEnableOption "fish" // {
      default = defaultUserShell == pkgs.fish;
    };
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.fish = {
      enable = true;

      generateCompletions = true;
    };

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      xdg = {
        data.directories = [
          "fish"
        ];
        config.directories = [
          "fish"
        ];
      };
    };
  };

}
