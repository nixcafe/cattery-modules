{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;

  # simplified and community-driven man pages
  pkg = pkgs.tlrc;

  cfg = config.${namespace}.cli-apps.tool.tldr;
in
{
  options.${namespace}.cli-apps.tool.tldr = with types; {
    enable = lib.mkEnableOption "tldr";
    period = mkOption {
      type = str;
      default = "weekly";
    };
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkg
    ];

    services.tldr-update = {
      inherit (cfg) period;

      enable = true;
      package = pkg;
    };

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      xdg.cache.directories = [ "tlrc" ];
    };
  };

}
