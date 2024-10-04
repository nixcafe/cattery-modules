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
        boot.kernel = mkDefaultEnabled;
      };

      # shared
      nix = mkDefaultEnabled;
      cli-apps = {
        openssh = mkDefaultEnabled;
        shell.zsh = mkDefaultEnabled;
      };
      system = {
        ulimit = mkDefaultEnabled;
      };
    };

  };
}
