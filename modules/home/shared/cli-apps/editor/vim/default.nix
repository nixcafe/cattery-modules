{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.cli-apps.editor.vim;
in
{
  options.${namespace}.cli-apps.editor.vim = with types; {
    enable = lib.mkEnableOption "vim";
    extraOptions = mkOption {
      type = attrs;
      default = { };
      description = ''
        Extra options to pass to the vim home-manager module.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    programs.vim = {
      enable = true;
    }
    // cfg.extraOptions;
  };

}
