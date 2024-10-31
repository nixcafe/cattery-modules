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
    ;
  inherit (pkgs.stdenv) isLinux;

  getAbsolutePath =
    attrName: prefix: list:
    map (
      x:
      if builtins.isString x then
        "${prefix}/${x}"
      else if builtins.isAttrs x && builtins.isString x.attrName or null then
        x // { ${attrName} = "${prefix}/${x.${attrName}}"; }
      else
        x
    ) list;
  getFilePath = getAbsolutePath "file";
  getDirectoryPath = getAbsolutePath "directory";

  xdg = {
    # can only be used in home, otherwise infinite recursion encountered
    # old code: 
    #   getDirectory = removePrefix "${config.home.homeDirectory}/";
    #   (getDirectory config.xdg.userDirs.desktop)
    # so pin these directories
    userDirs = optionals (cfg.xdg.userDirs.enable && cfg.xdg.userDirs.full) [
      "Desktop"
      "Documents"
      "Downloads"
      "Music"
      "Pictures"
      "Public"
      "Templates"
      "Videos"
    ];
    cache = {
      directories = optionals cfg.xdg.cache.enable (
        if cfg.xdg.cache.full then [ ".cache" ] else getDirectoryPath ".cache" cfg.xdg.cache.directories
      );
      files = optionals (cfg.xdg.cache.enable && !cfg.xdg.cache.full) (
        getFilePath ".cache" cfg.xdg.cache.files
      );
    };
    config = {
      directories = optionals cfg.xdg.config.enable (
        if cfg.xdg.config.full then [ ".config" ] else getDirectoryPath ".config" cfg.xdg.config.directories
      );
      files = optionals (cfg.xdg.config.enable && !cfg.xdg.config.full) (
        getFilePath ".config" cfg.xdg.config.files
      );
    };
    data = {
      directories = optionals cfg.xdg.data.enable (
        if cfg.xdg.data.full then
          [ ".local/share" ]
        else
          getDirectoryPath ".local/share" cfg.xdg.data.directories
      );
      files = optionals (cfg.xdg.data.enable && !cfg.xdg.data.full) (
        getFilePath ".local/share" cfg.xdg.data.files
      );
    };
    state = {
      directories = optionals cfg.xdg.state.enable (
        if cfg.xdg.state.full then
          [ ".local/state" ]
        else
          getDirectoryPath ".local/state" cfg.xdg.state.directories
      );
      files = optionals (cfg.xdg.state.enable && !cfg.xdg.state.full) (
        getFilePath ".local/state" cfg.xdg.state.files
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
    persistence = mkOption {
      type = attrs;
      default = {
        files = xdg.cache.files ++ xdg.config.files ++ xdg.data.files ++ xdg.state.files;
        directories =
          [
            {
              directory = ".ssh";
              mode = "0700";
            }
          ]
          ++ xdg.userDirs
          ++ xdg.cache.directories
          ++ xdg.config.directories
          ++ xdg.data.directories
          ++ xdg.state.directories
          ++ cfg.directories;
      } // cfg.extraOptions;
      readOnly = true;
      internal = true;
      visible = false;
    };
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    # Because impermanence home-manager has too few functions,
    # such as the lack of mode, the results here will be called by nixos
    age.identityPaths = mkDefault [
      "/persistent${config.home.homeDirectory}/.ssh/id_ed25519"
      "/persistent${config.home.homeDirectory}/.ssh/id_rsa"
    ];
  };

}
