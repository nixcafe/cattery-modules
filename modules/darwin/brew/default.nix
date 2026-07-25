{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.brew;
in
{
  options.${namespace}.brew = with types; {
    enable = lib.mkEnableOption "brew";
    brews = mkOption {
      type = listOf str;
      default = [ ];
      description = "List of Homebrew formula packages to install.";
    };
    casks = mkOption {
      type = listOf str;
      default = [ ];
      description = "List of Homebrew cask packages to install.";
    };
  };

  config = lib.mkIf cfg.enable {
    homebrew = {
      inherit (cfg) brews casks;
      enable = true;
      onActivation = {
        autoUpdate = true;
        upgrade = true;
      };
    };

    environment = {
      systemPath = [
        "$BREW_HOME/bin"
      ];
      variables = {
        BREW_HOME = "/opt/homebrew";
      };
    };
  };
}
