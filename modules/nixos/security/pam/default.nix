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
    description = ''
      PAM configuration options.
    '';
  };

  config = lib.mkIf (cfg != { }) {
    security.pam = cfg;
  };
}
