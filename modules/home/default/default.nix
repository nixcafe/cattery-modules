{ inputs, ... }:
let
  homes-modules = with inputs; [
    agenix.homeManagerModules.default
    nix-index-database.hmModules.nix-index
    impermanence.nixosModules.home-manager.impermanence
  ];
in
{
  imports =
    (builtins.attrValues (builtins.removeAttrs inputs.self.homeModules [ "default" ])) ++ homes-modules;
}
