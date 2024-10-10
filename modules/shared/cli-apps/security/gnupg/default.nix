{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.security.gnupg;
in
{
  options.${namespace}.cli-apps.security.gnupg = {
    agent = {
      enable = lib.mkEnableOption "gnupg agent";
      enableSSHSupport = lib.mkEnableOption "gnupg agent ssh support";
    };
  };

  config = lib.mkIf cfg.agent.enable {
    programs.gnupg.agent = {
      inherit (cfg.agent) enable enableSSHSupport;
    };
  };

}
