{
  pkgs,
  lib,
  inputs,
  namespace,
  purr ? { },
  config,
  ...
}:
let
  inherit (lib)
    optionals
    optionalAttrs
    mkDefault
    mkOption
    types
    concatMap
    concatMapAttrs
    intersectLists
    mergeAttrsList
    foldl'
    unique
    ;

  cfg = config.${namespace}.containers;

  # The outer `config` is the host configuration. The submodule below also
  # uses the name `config`, so keep the host value under a distinct name.
  hostStateVersion = config.system.stateVersion;

  servicesEnum = [
    "postgresql"
    "vaultwarden"
    "nginx"
    "acme"
  ];
  sharedServicesEnum = [
    "wg-quick"
    "sing-box"
    "openssh"
  ];

  # generate container ip
  generateIps =
    let
      ctrNames = builtins.attrNames cfg;
      ctrIdxs = builtins.genList (i: i) (builtins.length ctrNames);
    in
    foldl' (
      acc: idx:
      acc
      // (
        let
          # idx: 0 1 2 -> ip: 2 3 4
          ip = toString (idx + 2);
        in
        {
          ${builtins.elemAt ctrNames idx} = {
            hostAddress = "172.30.3.1";
            hostAddress6 = "fc00::1";
            localAddress = "172.30.3.${ip}";
            localAddress6 = "fc00::${ip}";
          };
        }
      )
    ) { } ctrIdxs;

  # type
  containerType = types.submodule (
    { name, config, ... }:
    {
      options = with types; {
        autoStart = lib.mkEnableOption "Whether the container is automatically started at boot-time." // {
          default = true;
        };
        modules = mkOption {
          type = listOf raw;
          default = [ ];
          description = "Extra NixOS modules to import into the container's configuration.";
        };
        userName = mkOption {
          type = str;
          default = "root";
          description = "The primary user to configure inside the container.";
        };
        networkMode = mkOption {
          type = enum [
            "host"
            "none"
            "bridge"
          ];
          default = "none";
          description = ''
            `host` -- Share the host network namespace.
            `none` -- Use a private veth pair. Addresses are generated unless
            `autoGenerateStaticIp` is disabled.
            `bridge` -- Use a private veth pair and attach the host side to
            `hostBridge`.
          '';
        };
        hostBridge = mkOption {
          type = nullOr str;
          default = null;
          example = "br0";
          description = ''
            Put the host-side of the veth-pair into the named bridge.
            Only one of hostAddress* or hostBridge can be given.
            Only enabled when networkMode is bridge.
          '';
        };
        forwardPorts = mkOption {
          type = listOf attrs;
          default = [ ];
          example = [
            {
              protocol = "tcp";
              hostPort = 8080;
              containerPort = 80;
            }
          ];
          description = ''
            List of forwarded ports from host to container. Each forwarded port
            is specified by protocol, hostPort and containerPort. By default,
            protocol is tcp and hostPort and containerPort are assumed to be
            the same if containerPort is not explicitly given.
          '';
        };
        hostAddress = mkOption {
          type = nullOr str;
          default = if config.autoGenerateStaticIp then generateIps.${name}.hostAddress else null;
          example = "10.231.136.1";
          description = "IPv4 address of the host-side of the veth pair.";
        };
        hostAddress6 = mkOption {
          type = nullOr str;
          default = if config.autoGenerateStaticIp then generateIps.${name}.hostAddress6 else null;
          example = "fc00::1";
          description = "IPv6 address of the host-side of the veth pair.";
        };
        localAddress = mkOption {
          type = nullOr str;
          default = if config.autoGenerateStaticIp then generateIps.${name}.localAddress else null;
          example = "10.231.136.2";
          description = "IPv4 address of the container-side of the veth pair.";
        };
        localAddress6 = mkOption {
          type = nullOr str;
          default = if config.autoGenerateStaticIp then generateIps.${name}.localAddress6 else null;
          example = "fc00::2";
          description = "IPv6 address of the container-side of the veth pair.";
        };
        autoGenerateStaticIp = lib.mkEnableOption "generate container static ip" // {
          default = config.networkMode == "none" && config.hostBridge == null;
        };
        bindMounts = mkOption {
          type = attrs;
          default = { };
          example = literalExpression ''
            { "/home" = { hostPath = "/home/alice";
                          isReadOnly = false; };
            }
          '';
          description = ''
            An extra attribute set of directories that is bound to the container.
          '';
        };
        dns = mkOption {
          type = nullOr (listOf str);
          default = null;
          example = [
            "1.1.1.1"
            "8.8.8.8"
          ];
          description = ''
            DNS servers to configure inside the container. When set, the
            container no longer copies the host's resolv.conf, which otherwise
            breaks name resolution in private network namespaces.
          '';
        };
        hostModules = {
          enable = lib.mkEnableOption "Using host Modules." // {
            default = true;
          };
          src = mkOption {
            type = listOf path;
            default = [
              ./../../nixos
              ./../../shared
            ];
            description = ''
              Directories recursively scanned for NixOS modules to import into
              the container. Relative paths are relative to this module file.
            '';
          };
          exclude = mkOption {
            type = listOf path;
            default = [ ./../../nixos/containers ];
            description = ''
              Directories excluded from the recursive module scan. The
              containers module itself is excluded by default so a container
              does not inherit the host's container definitions.
            '';
          };
          # Automatically load and start
          autoLoader = {
            services = mkOption {
              type = listOf (enum servicesEnum);
              default = intersectLists [ "${name}" ] servicesEnum;
              description = "Host services to automatically enable and start in the container.";
            };
            shared.services = mkOption {
              type = listOf (enum sharedServicesEnum);
              default = intersectLists [ "${name}" ] sharedServicesEnum;
              description = "Shared services to automatically enable and start in the container.";
            };
            bindSecretsEtc = lib.mkEnableOption ''
              Binding host decryption secrets etc.
              The secret to enable the corresponding service.
            '';
          };
        };
        specialArgs = mkOption {
          type = types.attrsOf types.unspecified;
          default = { };
          description = ''
            A set of special arguments to be passed to NixOS modules.
            This will be merged into the `specialArgs` used to evaluate
            the NixOS configurations.
          '';
        };
        config = mkOption {
          type = types.deferredModule;
          default = { };
          description = "NixOS configuration module or attribute set to merge into the container's configuration.";
        };
        extraOptions = mkOption {
          type = attrs;
          default = { };
          description = "Extra attributes to merge at the top level of the container's NixOS configuration.";
        };
      };
    }
  );
in
{
  options.${namespace}.containers = mkOption {
    type = types.attrsOf containerType;
    default = { };
    description = "using `machinectl`";
  };

  config = {
    assertions = lib.concatLists (
      lib.mapAttrsToList (
        name: ctr:
        lib.optional
          (
            ctr.hostBridge != null
            && (
              ctr.hostAddress != null
              || ctr.hostAddress6 != null
              || ctr.localAddress != null
              || ctr.localAddress6 != null
            )
          )
          {
            assertion = false;
            message = "containers.${name}: hostBridge cannot be combined with hostAddress/localAddress; disable autoGenerateStaticIp or remove hostBridge.";
          }
        ++
          lib.optional
            (
              ctr.networkMode == "host"
              && (
                ctr.hostBridge != null
                || ctr.forwardPorts != [ ]
                || ctr.hostAddress != null
                || ctr.hostAddress6 != null
                || ctr.localAddress != null
                || ctr.localAddress6 != null
              )
            )
            {
              assertion = false;
              message = "containers.${name}: networkMode = \"host\" ignores hostBridge, forwardPorts, and static addresses; use networkMode = \"none\" or \"bridge\" for those options.";
            }
        ++ lib.optional (ctr.networkMode == "bridge" && ctr.hostBridge == null) {
          assertion = false;
          message = "containers.${name}: networkMode = \"bridge\" requires hostBridge.";
        }
      ) cfg
    );

    containers = concatMapAttrs (name: ctr: {
      ${name} =
        let
          isExcluded =
            path:
            lib.any (
              excluded: path == excluded || lib.hasPrefix (toString excluded + "/") (toString path)
            ) ctr.hostModules.exclude;

          hostModulePaths = optionals ctr.hostModules.enable (
            unique (
              builtins.filter (path: !(isExcluded path)) (
                concatMap (src: inputs.purr.lib.loadModules src) ctr.hostModules.src
              )
            )
          );

          # Both NixOS and shared modules live under the same service option
          # tree (`cattery.services.<name>`). Keep the historical
          # `shared.services` option name for compatibility, but enable both
          # groups through `cattery.services`.
          autoServices = unique (
            ctr.hostModules.autoLoader.services ++ ctr.hostModules.autoLoader.shared.services
          );

          hostModules = with inputs; [
            impermanence.nixosModules.impermanence
            agenix.nixosModules.default
            home-manager.nixosModules.home-manager
            catppuccin.nixosModules.catppuccin
            lanzaboote.nixosModules.lanzaboote
            vscode-server.nixosModules.default
            nixos-wsl.nixosModules.default
            nix-gaming.nixosModules.pipewireLowLatency
          ];

          userAttrs =
            if ctr.hostModules.enable then
              { ${namespace}.user.name = mkDefault ctr.userName; }
            else
              {
                users.users.${ctr.userName} = lib.mkIf (ctr.userName != "root") {
                  isNormalUser = mkDefault true;
                  uid = mkDefault 1000;
                  group = mkDefault "users";
                  home = mkDefault "/home/${ctr.userName}";
                  extraGroups = mkDefault [ "wheel" ];
                };
              };

          autoLoader = optionalAttrs (ctr.hostModules.enable && autoServices != [ ]) {
            ${namespace}.services = mergeAttrsList (
              map (service: {
                ${service}.enable = mkDefault true;
              }) autoServices
            );
          };
        in
        {
          inherit (ctr)
            autoStart
            forwardPorts
            hostAddress
            hostAddress6
            localAddress
            localAddress6
            hostBridge
            ;

          privateNetwork = ctr.networkMode != "host";
          bindMounts =
            let
              autoLoaderSecrets =
                optionalAttrs (ctr.hostModules.enable && ctr.hostModules.autoLoader.bindSecretsEtc)
                  (
                    foldl' (
                      acc: serviceName:
                      let
                        service = lib.attrByPath [ "${namespace}" "services" serviceName ] { } config;
                        secrets = service.secrets or { };
                        etc = secrets.etc or { };
                        files = etc.files or { };
                        enabled = (secrets.enable or false) && (etc.enable or false);
                      in
                      if !enabled then
                        acc
                      else
                        foldl' (
                          fileAcc: filePath:
                          let
                            source = lib.attrByPath [ filePath "source" ] null files;
                          in
                          if source == null then
                            fileAcc
                          else
                            fileAcc
                            // {
                              "/etc/${filePath}" = {
                                hostPath = source;
                                isReadOnly = true;
                              };
                            }
                        ) acc (builtins.attrNames files)
                    ) { } autoServices
                  );
            in
            autoLoaderSecrets // ctr.bindMounts // (ctr.extraOptions.bindMounts or { });

          config = lib.mkMerge [
            {
              imports = ctr.modules ++ optionals ctr.hostModules.enable (hostModules ++ hostModulePaths);
              system.stateVersion = mkDefault hostStateVersion;

              # The host owns the block devices; fstrim inside a container is
              # ineffective and can fail when discard is unavailable.
              services.fstrim.enable = mkDefault false;
            }
            (optionalAttrs ctr.hostModules.enable {
              home-manager.users.${ctr.userName}.home.stateVersion = mkDefault hostStateVersion;
            })
            (optionalAttrs (ctr.dns != null) {
              # container-config.nix sets this to mkDefault true and the start
              # script copies the host resolv.conf into the container. That is
              # wrong for private network namespaces, where the host resolver
              # may not be reachable. 900 beats mkDefault but still lets users
              # override it in ctr.config.
              networking.useHostResolvConf = lib.mkOverride 900 false;
              networking.nameservers = ctr.dns;
            })
            (optionalAttrs (ctr.networkMode == "none") {
              # The container init script configures eth0 before systemd starts.
              # Keep NetworkManager (enabled by room.container) from replacing
              # those static addresses with its own DHCP configuration.
              networking.networkmanager.unmanaged = [ "eth0" ];
            })
            userAttrs
            autoLoader
            ctr.config
            (ctr.extraOptions.config or { })
          ];

          specialArgs =
            ctr.specialArgs
            // {
              inherit
                namespace
                inputs
                lib
                purr
                ;
              system = pkgs.stdenv.hostPlatform.system;
            }
            // (ctr.extraOptions.specialArgs or { });
        }
        // builtins.removeAttrs ctr.extraOptions [
          "config"
          "bindMounts"
          "specialArgs"
        ];
    }) cfg;
  };
}
