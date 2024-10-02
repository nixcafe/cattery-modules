{ inputs, ... }:
let
  homes-modules = with inputs; [
    nix-index-database.hmModules.nix-index
  ];
in
{
  imports =
    (builtins.attrValues (builtins.removeAttrs inputs.self.homeModules [ "default" ])) ++ homes-modules;
}
