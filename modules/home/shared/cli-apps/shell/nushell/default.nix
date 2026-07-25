{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;
  inherit (config.${namespace}.user) settings defaultUserShell;

  cfg = config.${namespace}.cli-apps.shell.nushell;
in
{
  options.${namespace}.cli-apps.shell.nushell = with types; {
    enable = lib.mkEnableOption "nushell" // {
      default = defaultUserShell == pkgs.nushell;
    };
    settings = mkOption {
      type = attrs;
      default = settings.nushell.settings or { };
      description = "Nushell configuration settings.";
    };
    extraConfig = mkOption {
      type = lines;
      default = "";
      description = "Extra Nushell configuration lines appended to config.nu.";
    };
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nushell = {
      inherit (cfg) settings extraConfig;

      enable = true;
      environmentVariables = config.home.sessionVariables;
    };

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      xdg.config.directories = [ "nushell" ];
    };
  };

}
