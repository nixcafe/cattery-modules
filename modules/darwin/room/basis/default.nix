{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkDefault;
  inherit (lib.${namespace}) mkDefaultEnabled;

  cfg = config.${namespace}.room.basis;
in
{
  options.${namespace}.room.basis = {
    enable = lib.mkEnableOption "room basis";
  };

  config = lib.mkIf cfg.enable {

    ${namespace} = {
      brew = mkDefaultEnabled;
      system = {
        sudoTouch = mkDefaultEnabled;
        useful = mkDefaultEnabled;
      };

      # shared
      nix = mkDefaultEnabled;
      cli-apps = {
        openssh = mkDefaultEnabled;
      };
      system = {
        fonts = mkDefaultEnabled;
        ulimit = {
          enable = mkDefault true;
          openFilesLimit = 4096;
        };
      };
    };

  };
}
