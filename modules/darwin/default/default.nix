{ inputs, lib, ... }:
let
  shared-modules = builtins.attrValues (lib.snowfall.module.create-modules { src = ../../shared; });
  darwin-modules = with inputs; [
    agenix.nixosModules.default
  ];
in
{
  imports =
    builtins.attrValues (builtins.removeAttrs inputs.self.darwinModules [ "default" ])
    ++ shared-modules
    ++ darwin-modules;
}
