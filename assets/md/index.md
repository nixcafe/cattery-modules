# cattery-modules

> Quick-start NixOS configurations. Choose a **room**, enable it, and get a complete system — theming, gaming, desktop, server, and more. No boilerplate.

A curated collection of Nix modules for NixOS, nix-darwin, and home-manager. Built with [purr](https://purr.nixcafe.org).

## Quick Start

```nix
# flake.nix
{
  inputs.cattery-modules.url = "https://flakehub.com/f/nixcafe/cattery-modules/*.tar.gz";

  outputs = { self, nixpkgs, cattery-modules, ... }: {
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      modules = [ cattery-modules.nixosModules.default ];
    };
  };
}
```

```nix
# configuration.nix
{ config, ... }: {
  cattery.room.desktop.dev.enable = true;
}
```

One line — full developer desktop with tools, theming, shell, and more.

## Why cattery-modules?

* **Room-based** — pre-configured module bundles; enable one and get dozens
* **Sensible defaults** — every module comes with good defaults, override what you need
* **Cross-platform** — NixOS, nix-darwin, home-manager, and NixOS-WSL
* **Modular** — use rooms for quick-start, or enable individual modules piece by piece
* **Extensible** — compose rooms with extra modules from other flakes
