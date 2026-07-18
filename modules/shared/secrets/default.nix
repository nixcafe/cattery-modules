{
  inputs,
  purr ? { },
  system,
  config,
  lib,
  namespace,
  ...
}:
let
  host = purr.host or purr.name or "localhost";
  inherit (lib)
    mkOption
    mkEnableOption
    concatMapAttrs
    types
    foldl'
    optionalAttrs
    ;
  inherit (config.age) secrets;
  inherit (config.users) users;

  cfg = config.${namespace}.secrets;

  # user home
  homeDir = config.${namespace}.user.home;

  # secrets path
  hosts-secrets = cfg.secretsPath;

  # type
  secretType =
    {
      owner ? "root",
      filePrefixPath,
      secretPrefixName ? filePrefixPath,
      ...
    }:
    types.submodule (
      { name, config, ... }:
      {
        options = with types; {
          name = mkOption {
            type = str;
            default = name;
          };
          secretName = mkOption {
            type = str;
            default = "${secretPrefixName}/${config.name}";
          };
          file = mkOption {
            type = path;
            default = "${hosts-secrets}/${filePrefixPath}/${config.name}.age";
          };
          mode = mkOption {
            type = str;
            default = "0400"; # Read-only
          };
          path = mkOption {
            type = str;
            default = secrets.${config.secretName}.path;
            readOnly = true;
          };
          symlink = mkEnableOption "symlinking secrets to their destination" // {
            default = true;
          };
          owner = mkOption {
            type = str;
            default = owner;
          };
          group = mkOption {
            type = str;
            default = users.${config.owner}.group or "0";
          };
        };
      }
    );

  secretSet =
    {
      prefixPath,
      prefixName ? prefixPath,
      ...
    }:
    with types;
    {
      users = mkOption {
        type = attrsOf (
          submodule (
            { name, ... }:
            {
              options.files = mkOption {
                type = attrsOf (secretType {
                  owner = name;
                  filePrefixPath = "${prefixPath}users/${name}";
                  secretPrefixName = "${prefixName}users/${name}";
                });
                default = { };
              };
            }
          )
        );
        default = { };
      };
      global.files = mkOption {
        type = attrsOf (secretType {
          owner = "root";
          filePrefixPath = "${prefixPath}global";
          secretPrefixName = "${prefixName}global";
        });
        default = { };
      };
    };

  # conversion
  toAgeSecrets =
    set:
    let
      globalFiles = builtins.attrValues set.global.files;
      usersFiles = builtins.concatMap (x: (builtins.attrValues x.files)) (builtins.attrValues set.users);
      files = globalFiles ++ usersFiles;
    in
    foldl' (
      acc: x:
      acc
      // {
        ${x.secretName} = {
          inherit (x)
            file
            mode
            symlink
            owner
            group
            path
            ;
          name = x.secretName;
        };
      }
    ) { } files;

in
{
  options.${namespace}.secrets = with types; {
    enable = mkEnableOption "secrets";
    yubikey.enable = mkEnableOption "yubikey support";
    secretsDir = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Folder where secrets are symlinked to
      '';
    };
    secretsMountPoint = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Where secrets are created before they are symlinked to {option}`age.secretsDir`
      '';
    };
    secretsPath = mkOption {
      type = path;
      default = "${homeDir}/agenix";
    };
    # hosts private config
    hosts = secretSet {
      prefixPath = "hosts/${host}/";
    };
    # shared config
    shared = secretSet {
      prefixPath = "shared/";
    };
    files = mkOption {
      type = attrs;
      default = (toAgeSecrets cfg.shared) // (toAgeSecrets cfg.hosts);
      readOnly = true;
    };
  };

  config = lib.mkIf cfg.enable {
    # agenix cli
    environment.systemPackages = [
      inputs.agenix.packages.${system}.default
      # (inputs.agenix.packages.${system}.default.override {
      #   plugins = optional cfg.yubikey.enable pkgs.age-plugin-yubikey;
      # })
    ];

    # secrets
    age = {
      secrets = concatMapAttrs (name: item: {
        ${name} = builtins.removeAttrs item [ "path" ];
      }) cfg.files;
    }
    // optionalAttrs (cfg.secretsDir != null) {
      inherit (cfg) secretsDir;
    }
    // optionalAttrs (cfg.secretsMountPoint != null) {
      inherit (cfg) secretsMountPoint;
    };
  };

}
