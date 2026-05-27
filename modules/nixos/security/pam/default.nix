{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.security.pam;
in
{
  options.${namespace}.security.pam = lib.mkOption {
    type = lib.types.attrs;
    default = { };
  };

  config = lib.mkIf cfg.enable {
    security.pam = cfg;
  };
}
