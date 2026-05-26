{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib)
    types
    mkOption
    ;

  cfg = config.${namespace}.cli-apps.security.gnupg;
in
{
  options.${namespace}.cli-apps.security.gnupg = {
    agent = {
      enable = lib.mkEnableOption "gnupg agent";
      enableSSHSupport = lib.mkEnableOption "gnupg agent ssh support";
      extraOptions = mkOption {
        type = types.attrs;
        default = { };
      };
    };
  };

  config = lib.mkIf cfg.agent.enable {
    programs.gnupg.agent = {
      inherit (cfg.agent)
        enable
        enableSSHSupport
        ;
    }
    // cfg.agent.extraOptions;
  };

}
