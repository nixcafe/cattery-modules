{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkDefaultEnabled;

  cfg = config.${namespace}.room.basis;
in
{
  options.${namespace}.room.basis = {
    enable = lib.mkEnableOption "room basis";
  };

  config = lib.mkIf cfg.enable {
    ${namespace} = {
      cli-apps = {

        dev-kit = {
          git = mkDefaultEnabled;
          nix = mkDefaultEnabled;
        };

        nix = {
          home-manager = mkDefaultEnabled;
          nix-index = mkDefaultEnabled;
        };

      };
    };
  };
}
