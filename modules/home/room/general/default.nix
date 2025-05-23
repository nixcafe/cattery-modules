{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkDefault;
  inherit (lib.${namespace}) mkDefaultEnabled;

  cfg = config.${namespace}.room.general;
in
{
  options.${namespace}.room.general = {
    enable = lib.mkEnableOption "room general";
  };

  config = lib.mkIf cfg.enable {
    ${namespace} = {
      room.basis = mkDefaultEnabled;

      cli-apps = {
        shell = {
          atuin = mkDefaultEnabled;
          direnv = mkDefaultEnabled;
          starship = mkDefaultEnabled;
          nushell = mkDefaultEnabled;
          # darwin config
          powershell = mkDefaultEnabled;
        };

        tool = {
          http-utils = mkDefaultEnabled;
          monitoring = mkDefaultEnabled;
          network = mkDefaultEnabled;
          compressor = mkDefaultEnabled;
          useful = {
            enable = mkDefault true;
            commonAliases = mkDefault true;
          };
          tldr = mkDefaultEnabled;
          misc = mkDefaultEnabled;
        };

        file-manager = {
          yazi = mkDefaultEnabled;
        };

        # linux config
        disk = mkDefaultEnabled;
        misc = mkDefaultEnabled;
      };
    };
  };
}
