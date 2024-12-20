{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkDefault mkOption types;

  identityPaths =
    if (config.services.openssh.enable or false) then
      map (e: e.path) (
        lib.filter (e: e.type == "rsa" || e.type == "ed25519") config.services.openssh.hostKeys
      )
    else
      [
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_rsa_key"
      ];

  cfg = config.${namespace}.system.impermanence;
in
{
  options.${namespace}.system.impermanence = with types; {
    enable = lib.mkEnableOption "impermanence";
    directories = mkOption {
      type = listOf raw;
      default = [ ];
    };
    files = mkOption {
      type = listOf raw;
      default = [ ];
    };
    extraOptions = mkOption {
      type = attrs;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    # see: https://github.com/nix-community/impermanence?tab=readme-ov-file#system-setup
    environment.persistence."/persistent" = {
      enable = true; # NB: Defaults to true, not needed
      hideMounts = true;
      directories = [
        # var
        "/var/log"
        "/var/lib"
        # etc
        "/etc/NetworkManager/system-connections"
        "/etc/ssh"
      ] ++ cfg.directories;
      files = [
        "/etc/machine-id"
      ] ++ cfg.files;
    } // cfg.extraOptions;

    # allow non-root users to specify the allow_other or allow_root mount options, see mount.fuse3(8).
    programs.fuse.userAllowOther = true;

    age.identityPaths = mkDefault (map (x: "/persistent${x}") identityPaths);
  };

}
