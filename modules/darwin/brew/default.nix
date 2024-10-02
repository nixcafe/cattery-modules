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
    };
    casks = mkOption {
      type = listOf str;
      default = [ ];
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

    ${namespace}.home.extraOptions = {
      programs = {
        zsh.initExtra = lib.mkAfter ''
          # brew
          export BREW_HOME="/opt/homebrew"
          # check brew home exists in path
          if [[ ":$PATH:" != *":$BREW_HOME/bin:"* ]]; then
              export PATH="$PATH:$BREW_HOME/bin"
          fi
        '';
      };
    };
  };
}
