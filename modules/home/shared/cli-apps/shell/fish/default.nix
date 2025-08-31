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
  };

  config = lib.mkIf cfg.enable {
    programs.fish = {
      enable = true;

      generateCompletions = true;
    };
  };

}
