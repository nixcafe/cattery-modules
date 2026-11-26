{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.operations.cloud;
in
{
  options.${namespace}.cli-apps.operations.cloud = {
    enable = lib.mkEnableOption "cloud";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # cloud
      aliyun-cli
      turso-cli
      awscli2
    ];

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      # Aliyun CLI keeps profiles, plugin caches, and downloaded extensions
      # under ~/.aliyun. AWS CLI keeps profiles, credentials, and SSO cache
      # under ~/.aws. Turso stores its settings under ~/.config/turso.
      directories = [
        ".aliyun"
        ".aws"
      ];
      files = [
        ".ossutilconfig"
      ];
      xdg.config.directories = [
        "turso"
      ];
    };
  };

}
