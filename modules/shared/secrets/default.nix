{
  pkgs,
  inputs,
  host,
  system,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib)
    mkOption
    mkEnableOption
    optional
    concatMapAttrs
    types
    foldl'
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
      (inputs.agenix.packages.${system}.default.override {
        plugins = optional cfg.yubikey.enable pkgs.age-plugin-yubikey;
      })
    ];

    # secrets
    age.secrets = concatMapAttrs (name: item: {
      ${name} = builtins.removeAttrs item [ "path" ];
    }) cfg.files;
  };

}
