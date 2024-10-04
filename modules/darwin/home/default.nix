{
  options,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types mkAliasDefinitions;
in
{
  options.${namespace}.home = with types; {
    extraOptions = mkOption {
      type = attrs;
      default = { };
    };
  };

  config = {
    # home manager config
    home-manager = {
      users.${config.${namespace}.user.name} = mkAliasDefinitions options.${namespace}.home.extraOptions;
    };
  };
}
