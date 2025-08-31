{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (config.${namespace}.user) defaultUserShell;

  cfg = config.${namespace}.cli-apps.shell.zsh;
in
{
  options.${namespace}.cli-apps.shell.zsh = {
    enable = lib.mkEnableOption "zsh" // {
      default = defaultUserShell == pkgs.zsh;
    };
  };

  config = lib.mkIf cfg.enable {
    # create /etc/zshrc that loads the environment
    programs.zsh.enable = true;
  };

}
