{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;
  inherit (lib)
    mkOption
    types
    concatMapAttrs
    foldl'
    ;
  inherit (lib.${namespace}) mkMappingOption;
  inherit (config.age) secrets;

  cfgParent = config.${namespace}.cli-apps.security.gnupg;
  cfg = cfgParent.secrets;

  onlyOwner = {
    inherit (config.users.users.${cfg.owner}) uid;
    # Read-only
    mode = "0000";
  };
in
{
  options.${namespace}.cli-apps.security.gnupg.secrets = with types; {
    enable = lib.mkEnableOption "gnupg" // {
      # If gnupg is started, secrets are enabled by default
      default = cfgParent.enable && config.${namespace}.secrets.enable;
    };
    etc = {
      enable = lib.mkEnableOption "bind to etc" // {
        default = true;
      };
      useSymlink = lib.mkEnableOption "use symlink to etc" // {
        default = isDarwin || (onlyOwner.uid == null);
      };
      dirPath = mkOption {
        type = str;
        default = "gnupg";
        description = ''
          relative to the path of etc.
          Just like: `/etc/{etc.dirPath}`
        '';
      };
    };
    configNames = mkOption {
      type = listOf str;
      default = [ ];
    };
    files = foldl' (
      acc: name:
      acc
      // {
        ${name} = mkMappingOption rec {
          source = name;
          target = secrets."gnupg/${source}".path;
        };
      }
    ) { } cfg.configNames;
    owner = mkOption {
      type = str;
      default = "root";
      description = "The owner of the files.";
    };
  };

  config = lib.mkIf cfg.enable {
    # secrets
    ${namespace}.secrets.shared.gnupg.configFile = concatMapAttrs (_: value: {
      "${value.source}".beneficiary = cfg.owner;
    }) cfg.files;

    # etc configuration default path: `/etc/gnupg`
    environment.etc = lib.mkIf cfg.etc.enable (
      concatMapAttrs (name: value: {
        "${cfg.etc.dirPath}/${name}" = {
          source = value.target;
        } // (lib.optionalAttrs (!cfg.etc.useSymlink) onlyOwner);
      }) cfg.files
    );
  };
}
