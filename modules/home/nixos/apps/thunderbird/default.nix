{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;
  inherit (lib) mkDefault mkOption types;
  inherit (config.${namespace}) user;

  cfg = config.${namespace}.apps.thunderbird;
in
{
  options.${namespace}.apps.thunderbird = with types; {
    enable = lib.mkEnableOption "thunderbird";
    search = {
      enable = lib.mkEnableOption "thunderbird";
      default = mkOption {
        type = str;
        default = "Nix Packages";
      };
      privateDefault = mkOption {
        type = str;
        default = "Google";
      };
    };
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    programs.thunderbird = {
      enable = true;
      profiles.${user.name} = {
        isDefault = mkDefault true;
        withExternalGnupg = true;
        search = lib.mkIf cfg.search.enable {
          inherit (cfg.search) default privateDefault;
          force = true;
          order = mkDefault [
            "Nix Packages"
            "NixOS Options"
            "NixOS Wiki"
            "Google"
          ];
          engines = mkDefault {
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];

              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };

            "NixOS Options" = {
              urls = [
                {
                  template = "https://search.nixos.org/options";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];

              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@no" ];
            };

            "NixOS Wiki" = {
              urls = [ { template = "https://wiki.nixos.org/index.php?search={searchTerms}"; } ];
              iconUpdateURL = "https://wiki.nixos.org/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = [ "@nw" ];
            };

            "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
          };
        };
      };
    };

    # add user to home accounts
    accounts.email.accounts = lib.mkIf user.addToAccounts {
      ${user.name}.thunderbird = {
        enable = true;
      };
    };

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      directories = [
        ".thunderbird"
      ];
      xdg.cache.directories = [
        "thunderbird"
      ];
    };
  };

}
