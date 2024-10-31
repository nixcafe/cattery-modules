{
  pkgs,
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
    enable = lib.mkEnableOption "gnupg";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      gpgme
    ];

    programs.gpg = {
      enable = true;
      scdaemonSettings = {
        disable-ccid = true;
      };
    };

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      directories = [
        {
          directory = ".gnupg";
          mode = "0700";
        }
      ];
    };
  };

}
