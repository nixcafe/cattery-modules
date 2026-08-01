{
  pkgs,
  lib,
  namespace,
  config,
  purr,
  ...
}:
let
  inherit (purr) isLinux isDarwin;
  inherit (lib)
    mkDefault
    mkOption
    types
    optionalAttrs
    ;

  linuxUserGroup = "users";
  user = config.users.users.${cfg.name};
  shadowPath = "shadow/${cfg.name}";
  passwordFile = config.${namespace}.secrets.hosts.global.files.${shadowPath}.path;

  cfg = config.${namespace}.user;
in
{
  options.${namespace}.user = with types; {
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
        The real (full) name of the user. Consumed by home-manager for git/email config.
      '';
    };
    email = {
      address = mkOption {
        type = nullOr str;
        default = cfg.settings.email.address or null;
        description = ''
          The email address of the user. Consumed by home-manager, not directly by this module.
        '';
      };
      userName = mkOption {
        type = nullOr str;
        default = cfg.email.address;
        description = ''
          The server username of this account. This will be used as
          the SMTP, IMAP, and JMAP user name. Consumed by home-manager.
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
        description = ''
          IMAP account configuration. Consumed by home-manager for email account configuration.
        '';
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
        description = ''
          SMTP account configuration. Consumed by home-manager for email account configuration.
        '';
      };
    };
    home = mkOption {
      type = nullOr str;
      default = user.home;
      readOnly = true;
      description = ''
        The path to the user's home directory.
      '';
    };
    uid = mkOption {
      type = nullOr int;
      default = user.uid;
      readOnly = true;
      description = ''
        The user ID (UID) of the user.
      '';
    };
    gid = mkOption {
      type = nullOr int;
      default = if isLinux then config.users.groups.${linuxUserGroup}.gid else user.gid;
      readOnly = true;
      description = ''
        The group ID (GID) of the user's primary group.
      '';
    };
    useSecretPasswordFile = mkOption {
      type = bool;
      default = false;
      description = ''
        Whether to use a secret password file instead of `hashedPasswordFile`.
        Also sets `mutableUsers = false` when enabled (Linux only).
        Configures agenix integration for the password file.
      '';
    };
    initialHashedPassword = mkOption {
      type = nullOr str;
      default = cfg.settings.initialHashedPassword or null;
      description = ''
        An initial hashed password for the user account (Linux only).
        Use `mkpasswd -m scrypt` to generate.
      '';
    };
    authorizedKeys = {
      keys = lib.mkOption {
        type = listOf singleLineStr;
        default = cfg.settings.authorizedKeys.keys or [ ];
        description = ''
          A list of SSH authorized keys as strings.
        '';
      };
      keyFiles = lib.mkOption {
        type = listOf path;
        default = [ ];
        description = ''
          A list of paths to files containing SSH authorized keys.
        '';
      };
    };
    gpg = {
      signKey = mkOption {
        type = nullOr str;
        default = cfg.settings.gpg.signKey or null;
        description = ''
          The GPG key used for signing. Consumed by home-manager for GPG signing configuration.
        '';
      };
      encryptKey = mkOption {
        type = nullOr str;
        default = cfg.settings.gpg.encryptKey or null;
        description = ''
          The GPG key used for encryption. Consumed by home-manager for GPG encryption configuration.
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
        The default login shell for the user. On Linux, sets the system-wide
        `users.defaultUserShell`. On Darwin, sets the per-user shell.
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

  config = lib.mkMerge [
    (optionalAttrs isDarwin {
      users.users.${cfg.name} = {
        # Just to ensure that it is not null when accessing, the default value on Mac is 501
        uid = 501;
        # macOS root lives outside /Users; everyone else under /Users/<name>.
        # home-manager reads `users.users.<name>.home` for `home.homeDirectory`.
        home = if cfg.name == "root" then "/var/root" else "/Users/${cfg.name}";
        openssh.authorizedKeys = cfg.authorizedKeys;
        shell = cfg.defaultUserShell;
      };
      # default shell
      environment.shells = [ cfg.defaultUserShell ];

      # The user used for options that previously applied to the user running `darwin-rebuild`.
      # see: https://github.com/nix-darwin/nix-darwin/blob/master/modules/system/primary-user.nix
      system.primaryUser = cfg.name;
    })

    (optionalAttrs isLinux {
      users = {
        users.${cfg.name} =
          (optionalAttrs (cfg.name != "root") {
            isNormalUser = true;

            group = linuxUserGroup;
            # single user
            uid = 1000;
            home = "/home/${cfg.name}";

            # for sudo
            extraGroups = [ "wheel" ];
          })
          // {
            # `mkpasswd -m scrypt`
            inherit (cfg) initialHashedPassword;
            # https://github.com/NixOS/nixpkgs/issues/148044
            # https://discourse.nixos.org/t/how-to-use-users-users-name-passwordfile/12378
            hashedPasswordFile = if cfg.useSecretPasswordFile then passwordFile else null;
            openssh.authorizedKeys = cfg.authorizedKeys;
          };

        mutableUsers = mkDefault (!cfg.useSecretPasswordFile);
        # default shell
      }
      // (optionalAttrs (cfg.defaultUserShell != null) {
        inherit (cfg) defaultUserShell;
      });

      ${namespace}.secrets.hosts.global.files = optionalAttrs cfg.useSecretPasswordFile {
        ${shadowPath}.mode = "0440";
      };
    })
  ];
}
