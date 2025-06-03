{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;
  inherit (config.${namespace}) user;

  cfg = config.${namespace}.system.locale;
in
{
  options.${namespace}.system.locale = with types; {
    enable = lib.mkEnableOption "locale";
    defaultLocale = mkOption {
      type = str;
      default = user.settings.defaultLocale or "en_US.UTF-8";
      description = "The default locale to use for the system.";
    };
  };

  config = lib.mkIf cfg.enable {
    i18n.defaultLocale = cfg.defaultLocale;
  };

}
