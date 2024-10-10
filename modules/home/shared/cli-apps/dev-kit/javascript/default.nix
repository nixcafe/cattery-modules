{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;

  pnpmHome =
    if isDarwin then
      "/Users/${config.${namespace}.user.name}/Library/pnpm"
    else
      "$HOME/.local/share/pnpm";
  cfg = config.${namespace}.cli-apps.dev-kit.javascript;
in
{
  options.${namespace}.cli-apps.dev-kit.javascript = {
    enable = lib.mkEnableOption "javascript";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        # js
        nodejs_22
        corepack_22
        bun
        dprint
      ];
      sessionVariables = {
        PNPM_HOME = pnpmHome;
      };
      sessionPath = [
        "$PNPM_HOME"
      ];
    };
  };

}
