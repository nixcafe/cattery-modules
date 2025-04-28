{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib)
    optional
    mkOption
    types
    any
    ;
  inherit (pkgs.stdenv) isLinux;

  apps = [
    "rustdesk"
    "krdc"
    "remmina"
  ];

  cfg = config.${namespace}.apps.remote;
in
{
  options.${namespace}.apps.remote = with types; {
    enable = lib.mkEnableOption "remote";
    needs = mkOption {
      type = listOf (enum apps);
      default = apps;
    };
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    home.packages = builtins.filter (x: x != "") (
      map (
        x:
        if x == "rustdesk" then
          pkgs.rustdesk
        else if x == "krdc" then
          pkgs.kdePackages.krdc
        else
          pkgs.remmina
      ) cfg.needs
    );

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      xdg =
        let
          remminaDir = optional (any (x: x == "remmina") cfg.needs) "remmina";
        in
        {
          cache.directories = remminaDir;
          config.directories = remminaDir;
          data.directories = remminaDir;
        };
    };
  };

}
