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
  cfg = config.${namespace}.cli-apps.ssh;
  cfgSecrets = cfg.secrets;
in
{
  options.${namespace}.cli-apps.ssh = with types; {
    enable = lib.mkEnableOption "ssh";
    includeNames = mkOption {
      default = [ ];
      type = listOf str;
    };
    includes = mkOption {
      default = [ ];
      type = listOf str;
      description = ''
        File globs of ssh config files that should be included via the
        `Include` directive.

        See
        {manpage}`ssh_config(5)`
        for more information.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    programs.ssh =
      let
        includeFiles = map (name: cfgSecrets.files.${name}.target) (builtins.attrNames cfgSecrets.files);
        includes = includeFiles ++ cfg.includes;
      in
      {
        inherit includes;

        enable = true;
        enableDefaultConfig = false;
      };
  };

}
