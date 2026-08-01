{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
  inherit (lib)
    mkDefault
    mkIf
    mkMerge
    mkOption
    types
    optionalAttrs
    ;

  name = cfg.settings.name or "nixos";
  home = if isLinux then "/home/${name}" else "/Users/${name}";

  cfg = config.${namespace}.user;
in
{
  options.${namespace}.user = with types; {
    addToAccounts = lib.mkEnableOption "add user to home accounts";
    injectHomeUser = mkOption {
      type = bool;
      default = cfg.settings.injectHomeUser or true;
      description = ''
        Whether to inject the user into home-manager by setting
        `home.username` and `home.homeDirectory`. Disable this when the
        surrounding flake framework (e.g. purr) already injects the user.
        Can also be controlled via `settings.injectHomeUser`.
      '';
    };
    name = mkOption {
      type = str;
      default = cfg.settings.name or "nixos";
      description = ''
        The name of the user account.
      '';
    };
    realName = mkOption {
      type = nullOr str;
      default = cfg.settings.realName or cfg.name or null;
      description = ''
        The real (full) name of the user.
      '';
    };
    email = {
      address = mkOption {
        type = nullOr str;
        default = cfg.settings.email.address or null;
        description = ''
          The email address of the user.
        '';
      };
      userName = mkOption {
        type = nullOr str;
        default = cfg.email.address;
        description = ''
          The server username of this account. This will be used as
          the SMTP, IMAP, and JMAP user name.
        '';
      };
      imap = mkOption {
        type = nullOr (submodule {
          options = {
            host = mkOption {
              type = str;
              example = "imap.example.org";
              description = ''
                Hostname of IMAP server.
              '';
            };
            port = mkOption {
              type = nullOr port;
              default = 993;
              description = ''
                The port of the IMAP server.
              '';
            };
          };
        });
        default = cfg.settings.email.imap or null;
      };
      smtp = mkOption {
        type = nullOr (submodule {
          options = {
            host = mkOption {
              type = str;
              example = "smtp.example.org";
              description = ''
                Hostname of SMTP server.
              '';
            };
            port = mkOption {
              type = nullOr port;
              default = 587;
              description = ''
                The port of the SMTP server.
              '';
            };
          };
        });
        default = cfg.settings.email.smtp or null;
      };
    };
    home = mkOption {
      type = nullOr str;
      default = config.home.homeDirectory;
      readOnly = true;
      description = ''
        The path to the user's home directory.
      '';
    };
    gpg = {
      signKey = mkOption {
        type = nullOr str;
        default = cfg.settings.gpg.signKey or null;
        description = ''
          The GPG key used for signing.
        '';
      };
      encryptKey = mkOption {
        type = nullOr str;
        default = cfg.settings.gpg.encryptKey or null;
        description = ''
          The GPG key used for encryption.
        '';
      };
    };
    defaultUserShell = lib.mkOption {
      type = nullOr (either path shellPackage);
      default =
        if (cfg.settings.defaultUserShell or null) != null then
          pkgs.${cfg.settings.defaultUserShell}
        else
          null;
      description = ''
        The default login shell for the user.
      '';
    };
    settings = mkOption {
      type = attrs;
      default = { };
      description = ''
        Extra settings passed through from the flake configuration.
      '';
    };
  };

  config = mkMerge [
    (mkIf cfg.injectHomeUser {
      home = {
        username = mkDefault name;
        homeDirectory = mkDefault home;
      };
    })

    {
      # add user to home accounts
      accounts.email.accounts = lib.mkIf cfg.addToAccounts {
        ${name} = {
          inherit (cfg) realName;
          inherit (cfg.email) address userName imap;
          primary = mkDefault true;
          smtp =
            if cfg.email.smtp != null then
              {
                inherit (cfg.email.smtp) host port;
                tls = optionalAttrs (cfg.email.smtp.port == 587) {
                  enable = true;
                  useStartTls = true;
                };
              }
            else
              null;
          gpg = optionalAttrs (cfg.gpg.encryptKey != null) {
            key = cfg.gpg.encryptKey;
            signByDefault = true;
          };
        };
      };
    }
  ];
}
