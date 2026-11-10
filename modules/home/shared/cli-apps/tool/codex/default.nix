{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (config.${namespace}.user) settings;
  cfg = config.${namespace}.cli-apps.tool.codex;
in
{
  options.${namespace}.cli-apps.tool.codex = {
    enable = lib.mkEnableOption "codex";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
    settings = lib.mkOption {
      type = lib.types.attrs;
      default = settings.codex.settings or { };
      description = ''
        Configuration written to `CODEX_HOME/config.toml`.
        See https://developers.openai.com/codex/config-reference for supported values.
      '';
    };
    context = lib.mkOption {
      type = lib.types.nullOr (lib.types.either lib.types.lines lib.types.path);
      default = settings.codex.context or null;
      description = ''
        Global context written to `CODEX_HOME/AGENTS.md`, either as inline
        content or a path to a file.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    programs.codex = {
      enable = true;
      inherit (cfg) settings;
      context = lib.mkIf (cfg.context != null) cfg.context;
    };

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      directories = lib.optionals (!config.home.preferXdgDirectories) [ ".codex" ];
      xdg.config.directories = lib.optionals config.home.preferXdgDirectories [ "codex" ];
    };
  };
}
