{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  inherit (lib)
    types
    mkOption
    ;

  cfg = config.${namespace}.services.gpg-agent;
  cfgDesktop = config.${namespace}.desktop;
in
{
  options.${namespace}.services.gpg-agent = {
    enable = lib.mkEnableOption "gpg-agent";
    enableSshSupport = lib.mkEnableOption "Whether to use the GnuPG key agent for SSH keys.";
    enableExtraSocket = lib.mkEnableOption "Whether to enable extra socket of the GnuPG key agent (useful for GPG Agent forwarding).";
    verbose = lib.mkEnableOption "Whether to produce verbose output.";
    sshKeys = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = null;
      description = ''
        Which GPG keys (by keygrip) to expose as SSH keys.
      '';
    };
    extraConfig = mkOption {
      type = types.lines;
      default = "";
      example = ''
        allow-emacs-pinentry
        allow-loopback-pinentry
      '';
      description = ''
        Extra configuration lines to append to the gpg-agent
        configuration file.
      '';
    };
    pinentry = {
      package = mkOption {
        type = types.nullOr types.package;
        default =
          if isDarwin then
            pkgs.pinentry_mac
          else if cfgDesktop.plasma.enable then
            pkgs.pinentry-qt
          else
            pkgs.pinentry-curses;
        description = ''
          Which pinentry interface to use. If not `null`, it sets
          {option}`pinentry-program` in {file}`gpg-agent.conf`. Beware that
          `pinentry-gnome3` may not work on non-GNOME systems. You can fix it by
          adding the following to your configuration:
          ```nix
          home.packages = [ pkgs.gcr ];
          ```
        '';
      };

      program = mkOption {
        type = types.nullOr types.str;
        default =
          if isDarwin then
            "pinentry-mac"
          else if cfgDesktop.plasma.enable then
            "pinentry-qt"
          else
            "pinentry-curses";
        example = "pinentry-wayprompt";
        description = ''
          Which program to search for in the configured `pinentry.package`.
        '';
      };
    };

    extraOptions = mkOption {
      type = types.attrs;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    services.gpg-agent = {
      inherit (cfg)
        extraConfig
        enableSshSupport
        enableExtraSocket
        sshKeys
        verbose
        ;

      enable = true;
      pinentry = {
        inherit (cfg.pinentry)
          package
          program
          ;
      };
    }
    // cfg.extraOptions;
  };
}
