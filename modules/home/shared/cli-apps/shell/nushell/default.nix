{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;
  inherit (config.${namespace}.user) settings;

  cfg = config.${namespace}.cli-apps.shell.nushell;
in
{
  options.${namespace}.cli-apps.shell.nushell = with types; {
    enable = lib.mkEnableOption "nushell";
    settings = mkOption {
      type = attrs;
      default = settings.nushell.settings or { };
    };
    extraConfig = mkOption {
      type = lines;
      default = '''';
    };
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nushell = {
      inherit (cfg) settings extraConfig;

      enable = true;
    };

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      xdg.config.directories = [ "nushell" ];
    };
  };

}
