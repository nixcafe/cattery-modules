{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.tool.compressor;
in
{
  options.${namespace}.cli-apps.tool.compressor = {
    enable = lib.mkEnableOption "compressor";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # cli stuff
      p7zip
      gzip
      zip
      unzip
      xz # a general-purpose data compression software, successor of LZMA
      zstd # zstandard real-time compression algorithm
    ];
  };

}
