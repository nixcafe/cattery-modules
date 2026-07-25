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
            description = ''
              Name of the secret used as a local identifier.
            '';
          };
          secretName = mkOption {
            type = str;
            default = "${secretPrefixName}/${config.name}";
            description = ''
              Full qualified name used as the key in {option}`age.secrets`.
            '';
          };
          file = mkOption {
            type = path;
            default = "${hosts-secrets}/${filePrefixPath}/${config.name}.age";
            description = ''
              Path to the age-encrypted secret file.
            '';
          };
          mode = mkOption {
            type = str;
            default = "0400";
            description = ''
              File permission mode of the decrypted secret.
            '';
          };
          path = mkOption {
            type = str;
            default = secrets.${config.secretName}.path;
            readOnly = true;
            description = ''
              Path where the decrypted secret will be placed.
            '';
          };
          symlink = mkEnableOption "symlinking secrets to their destination" // {
            default = true;
          };
          owner = mkOption {
            type = str;
            default = owner;
            description = ''
              User that owns the decrypted secret file.
            '';
          };
          group = mkOption {
            type = str;
            default = users.${config.owner}.group or "0";
            description = ''
              Group that owns the decrypted secret file.
            '';
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
                description = ''
                  Attribute set of user-specific secrets.
                '';
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
        description = ''
          Attribute set of global secrets shared across all users.
        '';
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
      description = ''
        Directory path containing the age-encrypted secret files.
      '';
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
      description = ''
        Merged attribute set of all agenix secrets from hosts and shared configurations.
      '';
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
