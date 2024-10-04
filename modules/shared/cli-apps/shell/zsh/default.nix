{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.shell.zsh;
in
{
  options.${namespace}.cli-apps.shell.zsh = {
    enable = lib.mkEnableOption "zsh";
  };

  config = lib.mkIf cfg.enable {
    # create /etc/zshrc that loads the environment
    programs.zsh.enable = true;
  };

}
