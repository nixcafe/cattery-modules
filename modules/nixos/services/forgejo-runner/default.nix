{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    mkPackageOption
    types
    ;

  cfg = config.${namespace}.services.forgejo-runner;
in
{
  options.${namespace}.services.forgejo-runner = with types; {
    enable = mkEnableOption "forgejo runner";
    package = mkPackageOption pkgs "forgejo-runner" { };

    instances = mkOption {
      type = attrsOf (
        submodule (
          { name, ... }:
          {
            options = {
              enable = mkEnableOption "this Forgejo Runner instance" // {
                default = true;
              };

              url = mkOption {
                type = str;
                example = "https://forge.example.com/";
                description = "Base URL of the Forgejo instance.";
              };

              uuid = mkOption {
                type = str;
                example = "c9e50be9-a7c3-4aee-ba35-624c4ff8c519";
                description = ''
                  UUID of the registered runner. When migrating from
                  `services.gitea-actions-runner`, take it from the existing
                  `.runner` file (for example
                  `/var/lib/gitea-runner/${name}/.runner`).
                '';
              };

              labels = mkOption {
                type = listOf str;
                default = [ ];
                example = [
                  "ubuntu-latest:docker://gitea/runner-images:ubuntu-latest"
                  "native:host"
                ];
                description = "Labels used to map jobs to their runtime environment.";
              };

              tokenFile = mkOption {
                type = path;
                default = "/etc/forgejo-runner/${name}.token";
                description = ''
                  Path to a file containing the runner token (just the token,
                  without a `TOKEN=` prefix). It is read through systemd
                  `LoadCredential=`, so it only needs to be readable by root.
                  Defaults to the agenix secret exposed by this module at
                  `/etc/forgejo-runner/<name>.token`.
                '';
              };

              settings = mkOption {
                type = attrs;
                default = { };
                description = ''
                  Extra settings merged into this instance's
                  `services.forgejo-runner.instances.<name>.settings`.
                '';
              };

              extraOptions = mkOption {
                type = attrs;
                default = { };
                description = "Extra options merged into this instance.";
              };
            };
          }
        )
      );
      default = { };
      description = "Forgejo Runner instances, keyed by instance name.";
    };

    extraOptions = mkOption {
      type = attrs;
      default = { };
      description = "Extra options merged into `services.forgejo-runner`.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.forgejo-runner = {
      inherit (cfg) package;

      instances = lib.mapAttrs (
        _name: value:
        lib.recursiveUpdate {
          inherit (value) enable;

          settings = lib.recursiveUpdate {
            server.connections.default = {
              inherit (value) url uuid;
            };
            runner.labels = value.labels;
          } value.settings;

          secrets.server.connections.default.token_url = value.tokenFile;
        } value.extraOptions
      ) cfg.instances;
    }
    // cfg.extraOptions;
  };
}
