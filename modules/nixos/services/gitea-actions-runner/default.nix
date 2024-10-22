{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib)
    mkOption
    mkEnableOption
    mkPackageOption
    types
    optionals
    concatMapAttrs
    ;

  cfgHostname = config.networking.hostName;
  cfgDocker = config.${namespace}.services.docker;

  cfg = config.${namespace}.services.gitea-actions-runner;
in
{
  options.${namespace}.services.gitea-actions-runner = with types; {
    enable = mkEnableOption "gitea actions runner";
    package = mkPackageOption pkgs "gitea-actions-runner" { };
    url = mkOption {
      type = str;
      example = "https://forge.example.com";
      description = ''
        Base URL of your Gitea/Forgejo instance.
        instances default url.
      '';
    };
    instances = mkOption {
      type = attrsOf (
        submodule (
          { name, config, ... }:
          {
            options = {
              enable = mkEnableOption "Gitea Actions Runner instance" // {
                default = true;
              };
              name = mkOption {
                type = str;
                default = name;
              };
              url = mkOption {
                type = str;
                default = cfg.url;
              };
              tokenFile = mkOption {
                type = nullOr (either str path);
                default = "/etc/gitea-runner/env/${config.name}.env";
                description = ''
                  Path to an environment file, containing the `TOKEN` environment
                  variable, that holds a token to register at the configured
                  Gitea/Forgejo instance.
                '';
              };
              labels = mkOption {
                type = listOf str;
                default = optionals cfgDocker.enable [
                  "ubuntu-latest:docker://gitea/runner-images:ubuntu-latest"
                  "ubuntu-22.04:docker://gitea/runner-images:ubuntu-22.04"
                  "ubuntu-20.04:docker://gitea/runner-images:ubuntu-20.04"
                ];
                description = ''
                  Labels used to map jobs to their runtime environment. Changing these
                  labels currently requires a new registration token.

                  Many common actions require bash, git and nodejs, as well as a filesystem
                  that follows the filesystem hierarchy standard.
                '';
              };
              settings = mkOption {
                type = attrs;
                default = { };
                description = ''
                  Configuration for `act_runner daemon`.
                  See https://gitea.com/gitea/act_runner/src/branch/main/internal/pkg/config/config.example.yaml for an example configuration
                '';
              };
              extraOptions = mkOption {
                type = attrs;
                default = { };
              };
            };
          }
        )
      );
      default = {
        ${cfgHostname} = { };
      };
    };
    extraOptions = mkOption {
      type = attrs;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    services.gitea-actions-runner = {
      inherit (cfg) package;
      instances = concatMapAttrs (name: value: {
        ${name} = {
          inherit (value)
            enable
            name
            url
            tokenFile
            labels
            settings
            ;
        } // value.extraOptions;
      }) cfg.instances;
    } // cfg.extraOptions;
  };
}
