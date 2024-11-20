{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib)
    mkDefault
    mkOption
    types
    optionals
    removePrefix
    ;
  inherit (pkgs.stdenv) isLinux;

  userName = config.${namespace}.user.name;

  getAbsolutePath =
    attrName: prefix: list:
    map (
      x:
      if builtins.isString x then
        "${prefix}/${x}"
      else if builtins.isAttrs x && builtins.isString x.${attrName} or null then
        x // { ${attrName} = "${prefix}/${x.${attrName}}"; }
      else
        x
    ) list;
  getFilePath = getAbsolutePath "file";
  getDirectoryPath = getAbsolutePath "directory";

  xdg =
    let
      getDirectory = removePrefix "${config.home.homeDirectory}/";
      cacheHome = getDirectory config.xdg.cacheHome;
      configHome = getDirectory config.xdg.configHome;
      dataHome = getDirectory config.xdg.dataHome;
      stateHome = getDirectory config.xdg.stateHome;
    in
    {
      userDirs = optionals (cfg.xdg.userDirs.enable && cfg.xdg.userDirs.full) [
        (getDirectory config.xdg.userDirs.desktop)
        (getDirectory config.xdg.userDirs.documents)
        (getDirectory config.xdg.userDirs.download)
        (getDirectory config.xdg.userDirs.music)
        (getDirectory config.xdg.userDirs.pictures)
        (getDirectory config.xdg.userDirs.publicShare)
        (getDirectory config.xdg.userDirs.templates)
        (getDirectory config.xdg.userDirs.videos)
      ];
      cache = {
        directories = optionals cfg.xdg.cache.enable (
          if cfg.xdg.cache.full then [ cacheHome ] else getDirectoryPath cacheHome cfg.xdg.cache.directories
        );
        files = optionals (cfg.xdg.cache.enable && !cfg.xdg.cache.full) (
          getFilePath cacheHome cfg.xdg.cache.files
        );
      };
      config = {
        directories = optionals cfg.xdg.config.enable (
          if cfg.xdg.config.full then
            [ configHome ]
          else
            getDirectoryPath configHome cfg.xdg.config.directories
        );
        files = optionals (cfg.xdg.config.enable && !cfg.xdg.config.full) (
          getFilePath configHome cfg.xdg.config.files
        );
      };
      data = {
        directories = optionals cfg.xdg.data.enable (
          if cfg.xdg.data.full then [ dataHome ] else getDirectoryPath dataHome cfg.xdg.data.directories
        );
        files = optionals (cfg.xdg.data.enable && !cfg.xdg.data.full) (
          getFilePath dataHome cfg.xdg.data.files
        );
      };
      state = {
        directories = optionals cfg.xdg.state.enable (
          if cfg.xdg.state.full then [ stateHome ] else getDirectoryPath stateHome cfg.xdg.state.directories
        );
        files = optionals (cfg.xdg.state.enable && !cfg.xdg.state.full) (
          getFilePath stateHome cfg.xdg.state.files
        );
      };
    };

  cfg = config.${namespace}.system.impermanence;
in
{
  # You have to use the home-manager NixOS module
  # (in the nixos directory of home-manager’s repo)
  # in order for this module to work as intended.
  options.${namespace}.system.impermanence = with types; {
    enable = lib.mkEnableOption "impermanence";
    xdg = {
      userDirs = {
        enable = lib.mkEnableOption "add xdg user directories to impermanence" // {
          default = true;
        };
        full = lib.mkEnableOption "if true, the entire directory will be added" // {
          default = true;
          readOnly = true;
        };
      };
      cache = {
        enable = lib.mkEnableOption "add xdg cache directories and file to impermanence" // {
          default = true;
        };
        full = lib.mkEnableOption "if true, the entire directory will be added";
        directories = mkOption {
          type = listOf raw;
          default = [ ];
        };
        files = mkOption {
          type = listOf raw;
          default = [ ];
        };
      };
      config = {
        enable = lib.mkEnableOption "add xdg config directories and file to impermanence" // {
          default = true;
        };
        full = lib.mkEnableOption "if true, the entire directory will be added";
        directories = mkOption {
          type = listOf raw;
          default = [ ];
        };
        files = mkOption {
          type = listOf raw;
          default = [ ];
        };
      };
      data = {
        enable = lib.mkEnableOption "add xdg data directories and file to impermanence" // {
          default = true;
        };
        full = lib.mkEnableOption "if true, the entire directory will be added";
        directories = mkOption {
          type = listOf raw;
          default = [ ];
        };
        files = mkOption {
          type = listOf raw;
          default = [ ];
        };
      };
      state = {
        enable = lib.mkEnableOption "add xdg state directories and file to impermanence" // {
          default = true;
        };
        full = lib.mkEnableOption "if true, the entire directory will be added";
        directories = mkOption {
          type = listOf raw;
          default = [ ];
        };
        files = mkOption {
          type = listOf raw;
          default = [ ];
        };
      };
    };
    directories = mkOption {
      type = listOf raw;
      default = [ ];
    };
    files = mkOption {
      type = listOf raw;
      default = [ ];
    };
    extraOptions = mkOption {
      type = attrs;
      default = { };
    };
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    home.persistence."/persistent/home/${userName}" = {
      files = xdg.cache.files ++ xdg.config.files ++ xdg.data.files ++ xdg.state.files;
      # all file permissions need to be set in the directory yourself
      # (if there are existing files, please copy them to the persistent directory intact)
      directories = map (x: if builtins.isAttrs x then builtins.removeAttrs x [ "mode" ] else x) (
        [
          {
            directory = ".ssh";
            mode = "0700";
          }
          {
            directory = ".pki";
            mode = "0700";
          }
        ]
        ++ xdg.userDirs
        ++ xdg.cache.directories
        ++ xdg.config.directories
        ++ xdg.data.directories
        ++ xdg.state.directories
        ++ cfg.directories
      );
      allowOther = true;
    } // cfg.extraOptions;

    age.identityPaths = mkDefault [
      "/persistent${config.home.homeDirectory}/.ssh/id_ed25519"
      "/persistent${config.home.homeDirectory}/.ssh/id_rsa"
    ];
  };

}
