{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  inherit (lib)
    any
    mkOption
    types
    optional
    optionalAttrs
    ;
  inherit (pkgs.stdenv) isDarwin;

  pnpmHome =
    if isDarwin then
      "/Users/${config.${namespace}.user.name}/Library/pnpm"
    else
      "$HOME/.local/share/pnpm";

  version = "24";
  nodejs = pkgs."nodejs_${version}";
  corepack = pkgs."corepack_${version}";
  cfg = config.${namespace}.cli-apps.dev-kit.javascript;
in
{
  options.${namespace}.cli-apps.dev-kit.javascript = with types; {
    enable = lib.mkEnableOption "javascript";
    needs = mkOption {
      type = listOf (enum [
        "pnpm"
        "yarn"
      ]);
      default = [ "pnpm" ];
    };
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        # js
        nodejs
        corepack
        bun
        dprint

        # automatic installation
        ni
      ];
      sessionVariables = optionalAttrs (any (x: x == "pnpm") cfg.needs) {
        PNPM_HOME = pnpmHome;
      };
      sessionPath = optional (any (x: x == "pnpm") cfg.needs) "$PNPM_HOME";
    };

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      directories = [ ".npm" ];
      xdg.cache.directories =
        [
          "node"
        ]
        ++ (builtins.filter (x: x != "") (
          map (
            x:
            if x == "pnpm" then
              "pnpm"
            else if x == "yarn" then
              "yarn"
            else
              ""
          ) cfg.needs
        ));
      xdg.data.directories = builtins.filter (x: x != "") (
        map (x: if x == "pnpm" then "pnpm" else "") cfg.needs
      );
      xdg.state.directories = builtins.filter (x: x != "") (
        map (x: if x == "pnpm" then "pnpm" else "") cfg.needs
      );
    };
  };

}
