{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;
  inherit (lib) mkDefault mkOption types;

  name = cfg.settings.name or "nixos";
  home = if isLinux then "/home/${name}" else "/Users/${name}";

  cfg = config.${namespace}.user;
in
{
  options.${namespace}.user = with types; {
    name = mkOption {
      type = str;
      default = config.home.username;
      readOnly = true;
    };
    nickname = mkOption {
      type = nullOr str;
      default = cfg.settings.nickname or cfg.name;
    };
    email = mkOption {
      type = nullOr str;
      default = cfg.settings.email or null;
    };
    home = mkOption {
      type = nullOr str;
      default = config.home.homeDirectory;
      readOnly = true;
    };
    signKey = mkOption {
      type = nullOr str;
      default = cfg.settings.signKey or null;
    };
    settings = mkOption {
      type = attrs;
      default = { };
    };
  };

  config = {
    home = {
      username = mkDefault name;
      homeDirectory = mkDefault home;
    };
  };
}
