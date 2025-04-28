{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.cli-apps.editor.neovim;
in
{
  options.${namespace}.cli-apps.editor.neovim = with types; {
    enable = lib.mkEnableOption "neovim";
    extraOptions = mkOption {
      type = attrs;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable = true;
    } // cfg.extraOptions;
  };

}
