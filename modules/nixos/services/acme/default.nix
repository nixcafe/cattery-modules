{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    concatMapAttrs
    optional
    ;
  inherit (lib.${namespace}.utils) getRootDomain;
  inherit (config.${namespace}) user;
  inherit (config.${namespace}.services) nginx;

  cfg = config.${namespace}.services.acme;
in
{
  options.${namespace}.services.acme = with types; {
    enable = lib.mkEnableOption "acme";
    useRoot = lib.mkEnableOption ''
      Whether to use the root user when generating certs. This is not recommended
      for security + compatibility reasons. If a service requires root owned certificates
      consider following the guide on "Using ACME with services demanding root
      owned certificates" in the NixOS manual, and only using this as a fallback
      or for testing.
    '';
    email = mkOption {
      type = nullOr str;
      default = user.email.address or null;
      description = ''
        Email address for ACME account registration and certificate expiration notices.
      '';
    };
    group = mkOption {
      type = str;
      default = if nginx.enable then "nginx" else "acme";
      description = ''
        Group owner of the ACME certificate directories.
      '';
    };
    dnsProvider = mkOption {
      type = nullOr str;
      default = "cloudflare";
      description = ''
        see the “code” field of the DNS providers listed at https://go-acme.github.io/lego/dns/.
      '';
    };
    postRun = mkOption {
      type = lines;
      default = "";
      description = ''
        Shell commands executed after a certificate is issued or renewed.
      '';
    };
    reloadServices = mkOption {
      type = listOf str;
      default = optional nginx.enable "nginx.service";
      description = ''
        Systemd services to reload after a certificate is issued or renewed.
      '';
    };
    certs = mkOption {
      type = attrs;
      default = { };
      description = ''
        ACME certificate configurations keyed by domain name.
      '';
    };
    extraOptions = mkOption {
      type = attrs;
      default = { };
      description = ''
        Extra options merged into the ACME service configuration.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    security.acme = {
      inherit (cfg) useRoot;
      defaults = {
        inherit (cfg)
          email
          group
          dnsProvider
          postRun
          reloadServices
          ;
      };
      certs = concatMapAttrs (name: value: {
        ${name} = {
          environmentFile = "/etc/acme/env/${getRootDomain name}.env";
        }
        // value;
      }) cfg.certs;
      acceptTerms = cfg.enable;
    }
    // cfg.extraOptions;
  };
}
