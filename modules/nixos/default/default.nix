{ inputs, lib, ... }:
let
  shared-modules = builtins.attrValues (lib.snowfall.module.create-modules { src = ../../shared; });
  nixos-modules = with inputs; [
    agenix.nixosModules.default
    lanzaboote.nixosModules.lanzaboote
    impermanence.nixosModules.impermanence
    vscode-server.nixosModules.default
    nixos-wsl.nixosModules.default
    nix-gaming.nixosModules.pipewireLowLatency
  ];
in
{
  imports =
    (builtins.attrValues (builtins.removeAttrs inputs.self.nixosModules [ "default" ]))
    ++ shared-modules
    ++ nixos-modules;
}
