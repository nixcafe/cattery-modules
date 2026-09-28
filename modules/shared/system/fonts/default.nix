{
  pkgs,
  config,
  lib,
  namespace,
  purr,
  ...
}:
let
  inherit (purr.meta) isLinux;
  inherit (lib) mkOption types;

  cfg = config.${namespace}.system.fonts;
in
{
  options.${namespace}.system.fonts = {
    enable = lib.mkEnableOption "fonts";

    packages = mkOption {
      type = types.listOf types.package;
      default = with pkgs; [
        open-sans
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji

        # Source Han is a set of Pan-CJK fonts from Adobe
        source-sans
        source-serif
        source-han-sans
        source-han-serif

        # DejaVu contains a lot of mathematical and other symbols, arrows, braille patterns
        dejavu_fonts
        # TODO port ttf-ms-win11-auto

        fira-code
        fira-code-symbols
        monaspace

        nerd-fonts.fira-code
        nerd-fonts.jetbrains-mono
        nerd-fonts.iosevka
        nerd-fonts.monaspace
      ];
      defaultText = lib.literalExpression "cattery default font packages";
      description = "Font packages to install system-wide.";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Additional font packages appended to {option}`packages`.";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      fonts.packages = cfg.packages ++ cfg.extraPackages;
    })

    (lib.optionalAttrs isLinux {
      fonts.fontDir.enable = true;
    })
  ];

}
