# Quick Start

## Installation

Add cattery as a flake input:

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    cattery-modules.url = "https://flakehub.com/f/nixcafe/cattery-modules/*.tar.gz";
  };
}
```

## NixOS

Import the bundled NixOS modules and enable a room:

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    cattery-modules.url = "https://flakehub.com/f/nixcafe/cattery-modules/*.tar.gz";
  };

  outputs = { nixpkgs, cattery-modules, ... }: {
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        cattery-modules.nixosModules.default
        ./configuration.nix
      ];
    };
  };
}
```

```nix
# configuration.nix
{ ... }: {
  cattery = {
    room.desktop.dev.enable = true;
    user.name = "alice";
  };
}
```

Then run `nixos-rebuild switch`.

## home-manager

Standalone home-manager works on Linux and macOS and does not need root access:

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    cattery-modules.url = "https://flakehub.com/f/nixcafe/cattery-modules/*.tar.gz";
  };

  outputs = { nixpkgs, home-manager, cattery-modules, ... }: {
    homeConfigurations.alice = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        cattery-modules.homeModules.default
        {
          cattery = {
            room.desktop.dev.enable = true;
            user.name = "alice";
          };
        }
      ];
    };
  };
}
```

```bash
home-manager switch --flake .#alice
```

## nix-darwin

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    darwin.url = "github:nix-darwin/nix-darwin";
    cattery-modules.url = "https://flakehub.com/f/nixcafe/cattery-modules/*.tar.gz";
  };

  outputs = { darwin, cattery-modules, ... }: {
    darwinConfigurations.macbook = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        cattery-modules.darwinModules.default
        {
          cattery = {
            room.basis.enable = true;
            user.name = "alice";
          };
        }
      ];
    };
  };
}
```

```bash
darwin-rebuild switch --flake .#macbook
```

## NixOS-WSL

```nix
{
  cattery = {
    room.desktop.wsl.enable = true;
    user.name = "alice";
  };
}
```

## Proxmox LXC

```nix
{
  cattery = {
    room.container.enable = true;
    system.proxmox.lxc.manageNetwork = true;
    user.name = "alice";
  };
}
```

## Individual modules

If you do not want a room, enable modules directly:

```nix
{
  cattery = {
    desktop.hyprland.enable = true;
    desktop.addons.catppuccin.enable = true;
    services.tailscale.enable = true;
    cli-apps.dev-kit.git.enable = true;
    cli-apps.dev-kit.rust.enable = true;
    cli-apps.shell.fish.enable = true;
    user.name = "alice";
  };
}
```

## Customizing rooms

Room sub-module enables use `lib.mkDefault`, so you can turn individual modules off or on:

```nix
{
  cattery = {
    room.desktop.dev.enable = true;

    # Override room defaults:
    cli-apps.dev-kit.javascript.enable = false; # use bun standalone
    desktop.hyprland.enable = false;
    desktop.niri.enable = true;
  };
}
```

## User information

Several modules read `cattery.user` for defaults, including git identity, email, GPG, and the login shell:

```nix
{ pkgs, ... }: {
  cattery.user = {
    name = "alice";
    realName = "Alice";
    email = {
      address = "alice@example.com";
      userName = "alice";
    };
    defaultUserShell = pkgs.fish; # also enables the fish module by default
    gpg.signKey = "ABCD1234";
  };
}
```

`cattery.user.home`, `uid`, and `gid` are read-only values taken from the system user.

## Next steps

* [Rooms](/rooms): see what each room enables
* [Modules](/modules): browse the module catalog
* [Secrets and agenix](/secrets): set up encrypted secrets
