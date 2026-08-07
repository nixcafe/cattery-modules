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
    calendar = mkOption {
      type = nullOr (submodule {
        options = {
          primary = mkOption {
            type = bool;
            default = true;
            description = ''
              Whether this is the primary calendar account.
            '';
          };
          primaryCollection = mkOption {
            type = nullOr str;
            default = null;
            description = ''
              The primary collection of the account. Required when the
              account has multiple collections.
            '';
          };
          local = mkOption {
            type = submodule {
              options = {
                path = mkOption {
                  type = str;
                  default = "${home}/.calendar/${name}";
                  description = "The path of the storage.";
                };
                type = mkOption {
                  type = enum [
                    "filesystem"
                    "singlefile"
                  ];
                  default = "filesystem";
                  description = "The type of the storage.";
                };
                fileExt = mkOption {
                  type = nullOr str;
                  default = ".ics";
                  description = "The file extension to use.";
                };
                encoding = mkOption {
                  type = nullOr str;
                  default = null;
                  description = ''
                    File encoding for items, both content and file name.
                  '';
                };
              };
            };
            default = { };
            description = "Local configuration for the calendar.";
          };
          remote = mkOption {
            type = nullOr (submodule {
              options = {
                type = mkOption {
                  type = enum [
                    "caldav"
                    "http"
                    "google_calendar"
                  ];
                  description = "The type of the storage.";
                };
                url = mkOption {
                  type = nullOr str;
                  default = null;
                  description = "The URL of the storage.";
                };
                userName = mkOption {
                  type = nullOr str;
                  default = cfg.email.userName;
                  description = "User name for authentication.";
                };
                passwordCommand = mkOption {
                  type = nullOr (listOf str);
                  default = null;
                  example = [
                    "pass"
                    "caldav"
                  ];
                  description = ''
                    A command that prints the password to standard output.
                  '';
                };
              };
            });
            default = null;
            description = "Remote configuration for the calendar.";
          };
        };
      });
      default = cfg.settings.calendar or null;
      description = ''
        The calendar account of the user. When set and
        `cattery.user.addToAccounts` is enabled, this is injected into
        `accounts.calendar.accounts`.${name}.
      '';
    };
    contact = mkOption {
      type = nullOr (submodule {
        options = {
          local = mkOption {
            type = submodule {
              options = {
                path = mkOption {
                  type = str;
                  default = "${home}/.contacts/${name}";
                  description = "The path of the storage.";
                };
                type = mkOption {
                  type = enum [
                    "filesystem"
                    "singlefile"
                  ];
                  default = "filesystem";
                  description = "The type of the storage.";
                };
                fileExt = mkOption {
                  type = nullOr str;
                  default = ".vcf";
                  description = "The file extension to use.";
                };
                encoding = mkOption {
                  type = nullOr str;
                  default = null;
                  description = ''
                    File encoding for items, both content and file name.
                  '';
                };
              };
            };
            default = { };
            description = "Local configuration for the contacts.";
          };
          remote = mkOption {
            type = nullOr (submodule {
              options = {
                type = mkOption {
                  type = enum [
                    "carddav"
                    "http"
                    "google_contacts"
                  ];
                  description = "The type of the storage.";
                };
                url = mkOption {
                  type = nullOr str;
                  default = null;
                  description = "The URL of the storage.";
                };
                userName = mkOption {
                  type = nullOr str;
                  default = cfg.email.userName;
                  description = "User name for authentication.";
                };
                passwordCommand = mkOption {
                  type = nullOr (listOf str);
                  default = null;
                  example = [
                    "pass"
                    "carddav"
                  ];
                  description = ''
                    A command that prints the password to standard output.
                  '';
                };
              };
            });
            default = null;
            description = "Remote configuration for the contacts.";
          };
        };
      });
      default = cfg.settings.contact or null;
      description = ''
        The contacts account of the user. When set and
        `cattery.user.addToAccounts` is enabled, this is injected into
        `accounts.contact.accounts`.${name}.
      '';
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

    (mkIf (cfg.addToAccounts && cfg.calendar != null) {
      accounts.calendar.accounts.${name} = {
        inherit (cfg.calendar)
          primary
          primaryCollection
          local
          remote
          ;
      };
    })

    (mkIf (cfg.addToAccounts && cfg.contact != null) {
      accounts.contact.accounts.${name} = {
        inherit (cfg.contact) local remote;
      };
    })
  ];
}
