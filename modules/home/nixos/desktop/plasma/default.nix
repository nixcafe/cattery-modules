{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;
  inherit (pkgs.stdenv) isLinux;
  inherit (config.${namespace}) user;

  cfg = config.${namespace}.desktop.plasma;
in
{
  options.${namespace}.desktop.plasma = with types; {
    enable = lib.mkEnableOption "plasma desktop configuration";
    settings = mkOption {
      type = attrs;
      default = user.settings.desktop.plasma or { };
      description = ''
        Plasma desktop settings:
        https://nix-community.github.io/plasma-manager/options.xhtml
      '';
    };
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    programs.plasma = {
      enable = true;
    } // cfg.settings;
  };
}
