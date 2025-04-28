{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    optional
    ;

  cfg = config.${namespace}.cli-apps.dev-kit.java;
in
{
  options.${namespace}.cli-apps.dev-kit.java = with types; {
    enable = lib.mkEnableOption "java";
    jdk = mkOption {
      type = package;
      default = pkgs.graalvmPackages.graalvm-ce;
      description = "The JDK to use.";
    };
    maven.enable = lib.mkEnableOption "maven";
    gradle = {
      enable = lib.mkEnableOption "gradle";
      home = mkOption {
        type = str;
        default = ".gradle";
      };
      initScripts = mkOption {
        type = attrs;
        default = { };
      };
      settings = mkOption {
        type = attrs;
        default = { };
      };
    };
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      java = {
        enable = true;
        package = cfg.jdk;
      };
      gradle = {
        inherit (cfg.gradle)
          enable
          home
          initScripts
          settings
          ;

        package = pkgs.gradle.override { java = cfg.jdk; };
      };
    };

    home.packages = optional cfg.maven.enable (pkgs.maven.override { jdk_headless = cfg.jdk; });

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      directories =
        [
          ".java"
        ]
        ++ optional cfg.gradle.enable cfg.gradle.home
        ++ optional cfg.maven.enable ".m2";
    };
  };

}
