{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;
  inherit (lib)
    mkDefault
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
    name = mkOption {
      type = str;
      default = config.home.username;
      readOnly = true;
    };
    realName = mkOption {
      type = nullOr str;
      default = cfg.settings.realName or cfg.name;
    };
    email = {
      address = mkOption {
        type = nullOr str;
        default = cfg.settings.email.address or null;
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
    };
    gpg = {
      signKey = mkOption {
        type = nullOr str;
        default = cfg.settings.gpg.signKey or null;
      };
      encryptKey = mkOption {
        type = nullOr str;
        default = cfg.settings.gpg.encryptKey or null;
      };
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

  };
}
