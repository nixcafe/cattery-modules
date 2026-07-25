{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.services.openssh;
in
{
  options.${namespace}.services.openssh = {
    enable = lib.mkEnableOption "openssh";
    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Extra configuration text loaded in {file}`sshd_config`.
        See {manpage}`sshd_config(5)` for help.
      '';
    };
    extraOptions = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Extra services.openssh nix-darwin options merged at top level.";
    };
  };

  config = {
    services.openssh = {
      inherit (cfg) extraConfig;

      # enable openssh
      enable = lib.mkDefault cfg.enable;
    }
    // cfg.extraOptions;
  };
}
