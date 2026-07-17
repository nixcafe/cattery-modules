# Quick Start

## Installation

Add cattery as a flake input:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    cattery-modules.url = "https://flakehub.com/f/nixcafe/cattery-modules/*.tar.gz";
  };
}
```

## Enabling a Room

Rooms are the fastest way to get started. Add the modules to your system config and enable a room:

```nix
# configuration.nix
{ cattery-modules, ... }: {
  imports = [ cattery-modules.nixosModules.default ];

  cattery.room.desktop.dev.enable = true;
}
```

That's it. Run `nixos-rebuild switch` and you'll have a fully configured developer desktop.

## Using with Home-Manager

Standalone home-manager (no NixOS):

```nix
# home.nix
{ cattery-modules, ... }: {
  imports = [ cattery-modules.homeModules.default ];

  cattery.room.desktop.dev.enable = true;
}
```

## Using with nix-darwin

macOS users:

```nix
{ cattery-modules, ... }: {
  imports = [ cattery-modules.darwinModules.default ];

  cattery.room.desktop.dev.enable = true;
}
```

## Picking Individual Modules

Don't want a full room? Enable modules one at a time:

```nix
{
  cattery = {
    themes.catppuccin.enable = true;
    desktop.hyprland.enable = true;
    services.tailscale.enable = true;
    cli-apps.dev-kit.git.enable = true;
  };
}
```
