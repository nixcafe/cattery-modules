{
  config,
  inputs,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.tool.kimi-code;
in
{
  options.${namespace}.cli-apps.tool.kimi-code = {
    enable = lib.mkEnableOption "kimi-code";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      inputs.kimi-code.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    # Kimi Code keeps config.toml and tui.toml under ~/.kimi-code.
    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      directories = [
        ".kimi-code"
      ];
    };
  };
}
