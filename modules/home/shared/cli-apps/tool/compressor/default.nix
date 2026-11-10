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
      # archive tools
      p7zip # 7z and other common formats
      unar # RAR, including RAR5

      # compression tools
      gzip
      bzip2
      zip
      unzip
      xz # general-purpose data compression, successor of LZMA
      zstd # Zstandard real-time compression
    ];
  };

}
