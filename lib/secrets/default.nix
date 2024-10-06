{ lib }:
let
  inherit (lib)
    types
    optionalAttrs
    mkOption
    mkEnableOption
    foldl'
    concatMapAttrs
    ;
in
{
  secrets = rec {
    scopeList = [
      "hosts-global"
      "hosts-user"
      "shared-global"
      "shared-user"
    ];

    getSecretPrefix =
      scope: host: user:
      if scope == "hosts-global" then
        "hosts/${host}/global"
      else if scope == "hosts-user" then
        "hosts/${host}/users/${user}"
      else if scope == "shared-global" then
        "shared/global"
      else if scope == "shared-user" then
        "shared/users/${user}"
      else
        "";

    mkMappingOption =
      {
        fileName,
        source,
        buildTarget ? (source: source),
        owner ? "root",
        group ? owner,
        mode ? "0400", # Read-only
        description ? "",
        ...
      }:
      types.submodule (
        { name, config, ... }:
        {
          options = {
            name = mkOption {
              type = types.str;
              default = name;
              readOnly = true;
            };
            fileName = mkOption {
              type = types.str;
              default = fileName;
            };
            source = mkOption {
              type = types.str;
              default = source;
              inherit description;
            };
            target = mkOption {
              type = types.str;
              default = buildTarget config.source;
              readOnly = true;
              inherit description;
            };
            mode = mkOption {
              type = types.str;
              default = mode;
            };
            owner = mkOption {
              type = types.str;
              default = owner;
              description = "The owner of the files.";
            };
            group = mkOption {
              type = types.str;
              default = group;
              description = "The group of the files.";
            };
          };
        }
      );

    mkHomeMappingOption =
      {
        fileName,
        source,
        buildTarget ? (source: source),
        mode ? "0400", # Read-only
        description ? "",
        ...
      }:
      types.submodule (
        { name, config, ... }:
        {
          options = {
            name = mkOption {
              type = types.str;
              default = name;
              readOnly = true;
            };
            fileName = mkOption {
              type = types.str;
              default = fileName;
            };
            source = mkOption {
              type = types.str;
              default = source;
              inherit description;
            };
            target = mkOption {
              type = types.str;
              default = buildTarget config.source;
              readOnly = true;
              inherit description;
            };
            mode = mkOption {
              type = types.str;
              default = mode;
            };
          };
        }
      );

    mkAppSecretsOption =
      {
        enable ? true,
        appName,
        dirPath ? appName,
        configNames ? [ ],
        fixedConfig ? [ ],
        scope ? "hosts-global",
        currentInfo,
        buildTargetPath ? (sourcePath: sourcePath),
        owner ? "root",
        group ? owner,
        mode ? "0400", # Read-only
        ...
      }:
      mkOption {
        type = types.submodule (
          { config, ... }:
          {
            options = {
              enable = mkEnableOption "enable ${appName} secrets" // {
                default = enable;
              };
              etc = {
                enable = mkEnableOption "bind to etc" // {
                  default = true;
                };
                useSymlink = mkEnableOption "use symlink to etc" // {
                  default = true;
                };
                dirPath = mkOption {
                  type = types.str;
                  default = dirPath;
                  description = ''
                    relative to the path of etc.
                    Just like: `/etc/{etc.dirPath}`
                  '';
                };
                files = mkOption {
                  type = types.attrs;
                  default = concatMapAttrs (_: item: {
                    "${config.etc.dirPath}/${item.fileName}" =
                      {
                        source = item.target;
                      }
                      // (optionalAttrs (!config.etc.useSymlink) {
                        inherit (item) mode group;
                        user = owner;
                      });
                  }) config.files;
                  readOnly = true;
                };
              };
              scope = mkOption {
                type = types.enum scopeList;
                default = scope;
              };
              secretMappingFiles = mkOption {
                type = types.attrs;
                default =
                  let
                    user = currentInfo.user or "root";
                    files = concatMapAttrs (_: item: {
                      "${item.source}" = {
                        inherit (item) mode owner group;
                      };
                    }) config.files;
                  in
                  if scope == "hosts-global" then
                    { hosts.global.files = files; }
                  else if scope == "hosts-user" then
                    { hosts.users.${user}.files = files; }
                  else if scope == "shared-global" then
                    { shared.global.files = files; }
                  else if scope == "shared-user" then
                    { shared.users.${user}.files = files; }
                  else
                    { };
                readOnly = true;
                internal = true;
                visible = false;
              };
              configNames = mkOption {
                type = types.listOf types.str;
                default = configNames;
              };
              files = foldl' (
                acc: item:
                acc
                // {
                  ${item.name} = mkOption {
                    type = mkMappingOption {
                      inherit (config) owner group mode;
                      fileName = item.fileName or item.name;
                      source = "${dirPath}/${item.fileName or item.name}";
                      buildTarget =
                        source:
                        (buildTargetPath "${
                          getSecretPrefix config.scope (currentInfo.host or "localhost") (currentInfo.user or "root")
                        }/${source}");
                      description = item.description or "The ${item.name} configuration file.";
                    };
                    default = { };
                  };
                }
              ) { } (fixedConfig ++ (map (name: { inherit name; }) config.configNames));
              mode = mkOption {
                type = types.str;
                default = mode;
              };
              owner = mkOption {
                type = types.str;
                default = owner;
                description = "The owner of the files.";
              };
              group = mkOption {
                type = types.str;
                default = group;
                description = "The group of the files.";
              };
            };
          }
        );
        default = { };
      };

    mkHomeAppSecretsOption =
      {
        enable ? true,
        appName,
        dirPath ? appName,
        configNames ? [ ],
        fixedConfig ? [ ],
        scope ? "hosts-user",
        currentInfo,
        buildTargetPath ? (sourcePath: sourcePath),
        mode ? "0400", # Read-only
        ...
      }:
      mkOption {
        type = types.submodule (
          { config, ... }:
          {
            options = {
              enable = mkEnableOption "enable ${appName} secrets" // {
                default = enable;
              };
              scope = mkOption {
                type = types.enum scopeList;
                default = scope;
              };
              secretMappingFiles = mkOption {
                type = types.attrs;
                default =
                  let
                    user = currentInfo.user or "root";
                    files = concatMapAttrs (_: item: {
                      "${item.source}" = {
                        inherit (item) mode;
                      };
                    }) config.files;
                  in
                  if scope == "hosts-global" then
                    { hosts.global.files = files; }
                  else if scope == "hosts-user" then
                    { hosts.users.${user}.files = files; }
                  else if scope == "shared-global" then
                    { shared.global.files = files; }
                  else if scope == "shared-user" then
                    { shared.users.${user}.files = files; }
                  else
                    { };
                readOnly = true;
                visible = false;
              };
              configNames = mkOption {
                type = types.listOf types.str;
                default = configNames;
              };
              files = foldl' (
                acc: item:
                acc
                // {
                  ${item.name} = mkOption {
                    type = mkHomeMappingOption {
                      inherit (config) mode;
                      fileName = item.fileName or item.name;
                      source = "${dirPath}/${item.fileName or item.name}";
                      buildTarget =
                        source:
                        (buildTargetPath "${
                          getSecretPrefix config.scope (currentInfo.host or "localhost") (currentInfo.user or "root")
                        }/${source}");
                      description = item.description or "The ${item.name} configuration file.";
                    };
                    default = { };
                  };
                }
              ) { } (fixedConfig ++ (map (name: { inherit name; }) config.configNames));
              mode = mkOption {
                type = types.str;
                default = mode;
              };
            };
          }
        );
        default = { };
      };
  };
}
