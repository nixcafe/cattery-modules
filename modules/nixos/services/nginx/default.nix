{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.services.nginx;
in
{
  options.${namespace}.services.nginx = {
    enable = lib.mkEnableOption "nginx";
    httpSubConfigPath = mkOption {
      type = types.str;
      default = "/etc/nginx/conf.d/*.conf";
      description = ''
        To make the configuration easier to maintain, we recommend that you split it into a set of 
        feature‑specific files stored in the `/etc/nginx/conf.d` directory and use the include directive in the 
        main `nginx.conf` file to reference the contents of the feature‑specific files.
      '';
    };
    commonHttpConfig = mkOption {
      type = types.lines;
      default = "";
    };
    httpConfig = mkOption {
      type = types.lines;
      default = "";
    };
    appendHttpConfig = mkOption {
      type = types.lines;
      default = "";
    };
    virtualHosts = mkOption {
      type = types.attrs;
      default = { };
    };
    preStart = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Shell commands executed before the service's nginx is started.
      '';
    };
    extraOptions = mkOption {
      type = types.attrs;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    services.nginx = {
      inherit (cfg)
        enable
        preStart
        httpConfig
        appendHttpConfig
        virtualHosts
        ;
      commonHttpConfig = lib.mkBefore (
        ''
          include ${cfg.httpSubConfigPath};
        ''
        + cfg.commonHttpConfig
      );
    }
    // cfg.extraOptions;
  };
}
