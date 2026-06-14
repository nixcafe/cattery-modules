{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.cli-apps.tool.gh;
in
{
  options.${namespace}.cli-apps.tool.gh = with types; {
    enable = lib.mkEnableOption "gh";
    settings = mkOption {
      type = attrs;
      default = { };
    };
    extraOptions = mkOption {
      type = attrs;
      default = { };
    };
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.gh = {
      inherit (cfg) settings;

      enable = true;
    }
    // cfg.extraOptions;

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      xdg.config.files = [
        "gh/hosts.yml"
      ];
      xdg.cache.directories = [ "gh" ];
    };
  };

}
