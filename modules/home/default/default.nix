{ inputs, ... }:
let
  homes-modules = with inputs; [
    agenix.homeManagerModules.default
    nix-index-database.hmModules.nix-index
  ];
in
{
  imports =
    (builtins.attrValues (builtins.removeAttrs inputs.self.homeModules [ "default" ])) ++ homes-modules;
}
