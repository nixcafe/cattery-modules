{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.dev-kit.rust;
in
{
  options.${namespace}.cli-apps.dev-kit.rust = {
    enable = lib.mkEnableOption "rust";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # rust
      rustup
      sccache
    ];

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      directories = [
        ".rustup"
        ".cargo"
      ];
    };
  };

}
