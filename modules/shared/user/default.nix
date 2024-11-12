{
  pkgs,
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux isDarwin;
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
    };
    realName = mkOption {
      type = nullOr str;
      default = cfg.settings.realName or cfg.name or null;
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
      default = user.home;
      readOnly = true;
    };
    uid = mkOption {
      type = nullOr int;
      default = user.uid;
      readOnly = true;
    };
    gid = mkOption {
      type = nullOr int;
      default = if isLinux then config.users.groups.${linuxUserGroup}.gid else user.gid;
      readOnly = true;
    };
    useSecretPasswordFile = lib.mkEnableOption "use secret password file to `hashedPasswordFile`";
    initialHashedPassword = mkOption {
      type = nullOr str;
      default = cfg.settings.initialHashedPassword or null;
    };
    authorizedKeys = {
      keys = lib.mkOption {
        type = listOf singleLineStr;
        default = cfg.settings.authorizedKeys.keys or [ ];
      };
      keyFiles = lib.mkOption {
        type = listOf path;
        default = [ ];
      };
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

  config = lib.mkMerge [
    (optionalAttrs isDarwin {
      users.users.${cfg.name} = {
        # Just to ensure that it is not null when accessing, the default value on Mac is 501
        uid = 501;
        openssh.authorizedKeys = cfg.authorizedKeys;
      };
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
      } // (optionalAttrs config.programs.zsh.enable { defaultUserShell = pkgs.zsh; });

      ${namespace}.secrets.hosts.global.files = optionalAttrs cfg.useSecretPasswordFile {
        ${shadowPath}.mode = "0440";
      };
    })
  ];
}
