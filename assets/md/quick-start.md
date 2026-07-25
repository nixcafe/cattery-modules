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

## NixOS (Full System)

The most common setup — full NixOS system with all modules available:

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

Run `nixos-rebuild switch` and you're done.

## home-manager (User-Level)

Standalone home-manager (Linux/macOS, no root access needed):

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

## nix-darwin (macOS)

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

## Proxmox LXC Container

```nix
{
  cattery = {
    room.container.enable = true;
    system.proxmox.lxc.manageNetwork = true;
    user.name = "alice";
  };
}
```

## Picking Individual Modules

Don't want a full room? Enable modules one at a time:

```nix
{
  cattery = {
    desktop.hyprland.enable = true;
    themes.catppuccin.enable = true;
    services.tailscale.enable = true;
    cli-apps.dev-kit.git.enable = true;
    cli-apps.dev-kit.rust.enable = true;
    cli-apps.shell.fish.enable = true;
    user.name = "alice";
  };
}
```

## Customizing Rooms

Rooms use `lib.mkDefault` for sub-module enables — you can opt out of anything:

```nix
{
  cattery = {
    room.desktop.dev.enable = true;
    # Override room defaults:
    cli-apps.dev-kit.javascript.enable = false;  # I use bun standalone
    desktop.hyprland.enable = false;              # I prefer Niri
    desktop.niri.enable = true;
  };
}
```

## Setting User Info

Many modules use `cattery.user` for defaults (git identity, email, GPG, shell):

```nix
{
  cattery.user = {
    name = "alice";
    email = {
      address = "alice@example.com";
      userName = "Alice";
    };
    defaultUserShell = "fish";  # auto-enables fish module
    gpg.signKey = "ABCD1234";
  };
}
```

## Next Steps

* **[Rooms](/rooms)** — see what each room includes
* **[Modules](/modules)** — browse all 244+ modules
* **[Secrets & agenix](/secrets)** — set up encrypted secrets
