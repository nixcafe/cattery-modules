{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkDefault;
  inherit (lib.${namespace}.module) mkDefaultEnabled;

  cfg = config.${namespace}.room.basis;
in
{
  options.${namespace}.room.basis = {
    enable = lib.mkEnableOption "room basis";
  };

  config = lib.mkIf cfg.enable {
    ${namespace} = {
      cli-apps = {
        mtr = mkDefaultEnabled;
        nix = {
          nix-ld = mkDefaultEnabled;
        };
      };

      services = {
        cron = mkDefaultEnabled;
        openssh = mkDefaultEnabled;
      };

      system = {
        locale = mkDefaultEnabled;
        network = mkDefaultEnabled;
        time = mkDefaultEnabled;
        boot.kernel.useLatest = mkDefault true;
      };

      # shared
      nix = mkDefaultEnabled;
      cli-apps = {
        openssh = mkDefaultEnabled;
      };
      system = {
        ulimit = mkDefaultEnabled;
      };
    };

  };
}
