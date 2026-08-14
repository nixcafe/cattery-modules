{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.tool.pi;
in
{
  options.${namespace}.cli-apps.tool.pi = {
    enable = lib.mkEnableOption "pi";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = ''
        Configuration written to `~/.pi/agent/settings.json`.
        See https://pi.dev/docs/latest/settings for the documentation.
      '';
    };
    models = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = ''
        Custom model providers written to `~/.pi/agent/models.json`.
        See https://pi.dev/docs/latest/models for the documentation.
      '';
    };
    context = lib.mkOption {
      type = lib.types.nullOr (lib.types.either lib.types.lines lib.types.path);
      default = null;
      description = ''
        Global context written to `~/.pi/agent/AGENTS.md`, either as inline
        content or a path to a file.
      '';
    };
    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = ''
        Extra packages available to pi, added to the PATH of the wrapped
        binary (e.g. `nodejs` and `bun` for npm-installed packages).
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    programs.pi-coding-agent = {
      enable = true;
      inherit (cfg) settings models extraPackages;
      context = lib.mkIf (cfg.context != null) cfg.context;
    };

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      directories = [
        ".pi"
      ];
    };
  };

}
