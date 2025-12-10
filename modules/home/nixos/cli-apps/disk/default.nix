{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  cfg = config.${namespace}.cli-apps.disk;
in
{
  options.${namespace}.cli-apps.disk = {
    enable = lib.mkEnableOption "disk";
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    home.packages = with pkgs; [
      # disk stuff
      ifuse # for ios
      mtools # NTFS
      nfs-utils # nfs
    ];
  };

}
