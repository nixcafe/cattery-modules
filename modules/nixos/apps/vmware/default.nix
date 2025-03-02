{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.apps.vmware;
in
{
  options.${namespace}.apps.vmware = {
    enable = lib.mkEnableOption "vmware";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.vmware = {
      guest.enable = true;
      host.enable = true;
    };

    ${namespace} = {
      home.extraOptions = {
        ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
          directories = [
            ".vmware"
          ];
        };
      };

      system.impermanence = lib.mkIf cfg.persistence {
        directories = [
          "/etc/vmware"
        ];
      };
    };
  };

}
