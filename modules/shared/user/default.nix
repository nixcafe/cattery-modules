{
  pkgs,
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux isDarwin;
  inherit (lib) mkOption types optionalAttrs;

  linuxUserGroup = "users";
  user = config.users.users.${cfg.name};

  cfg = config.${namespace}.user;
in
{
  options.${namespace}.user = with types; {
    name = mkOption {
      type = str;
      default = cfg.settings.name or "nixos";
    };
    nickname = mkOption {
      type = nullOr str;
      default = cfg.settings.nickname or cfg.name or null;
    };
    email = mkOption {
      type = nullOr str;
      default = cfg.settings.email or null;
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
            openssh.authorizedKeys = cfg.authorizedKeys;
          };
        # default shell
      } // (optionalAttrs config.programs.zsh.enable { defaultUserShell = pkgs.zsh; });
    })
  ];
}
