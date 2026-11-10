# cattery

cattery is a collection of 262 Nix modules for NixOS, nix-darwin, and home-manager. The modules are grouped into rooms: named sets of modules that enable each other with shared defaults. Enable a room to turn on a group of related features, then override the individual modules you want to change.

```nix
# flake.nix
{
  inputs.cattery-modules.url = "https://flakehub.com/f/nixcafe/cattery-modules/*.tar.gz";

  outputs = { nixpkgs, cattery-modules, ... }: {
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

`cattery.room.desktop.dev` enables the desktop chain and a set of developer tools. See [Rooms](/rooms) for the full contents of each room.

***

## What is a room?

A room is a module that enables other modules with `lib.mkDefault`. It does not add configuration of its own. Enabling a room also enables the rooms it depends on. This is the NixOS graph:

```
room.basis
 ├─ room.general                 (basis + boot.efi)
 ├─ room.server-mini             (basis + acme, optional cloud-init and qemu-guest)
 │   └─ room.server              (server-mini)
 │       └─ room.server.nas      (server + optional storage services)
 ├─ room.container               (basis + acme, boot.isContainer)
 └─ room.desktop.basis           (basis + desktop hardware and fonts)
     └─ room.desktop.general     (desktop.basis + boot.efi)
         ├─ room.desktop.dev      (desktop.general + dev tools)
         ├─ room.desktop.game     (desktop.general + steam)
         └─ room.desktop.wsl      (desktop.basis + wsl)
```

Home-manager has its own smaller chain and a standalone `room.game`. nix-darwin provides `room.basis` and `room.desktop.dev`.

Because sub-module enables use `lib.mkDefault`, explicit settings take precedence:

```nix
cattery.room.desktop.dev.enable = true;
cattery.apps.jetbrains.enable = false; # use neovim instead
```

***

## What cattery includes

| Feature | Notes |
|---|---|
| **262 modules** | Theming, desktops, gaming, services, CLI tools, development kits, security, and platform integration |
| **Room profiles** | Preset groups such as `room.desktop.dev` and `room.server` |
| **agenix secrets** | Encrypted configuration files for services such as nginx, PostgreSQL, Forgejo, WireGuard, and cloudflared |
| **Impermanence** | Ephemeral root and home with persistent state, including XDG user directories |
| **Platforms** | NixOS, nix-darwin, home-manager, NixOS-WSL, and Proxmox LXC |
| **Overrides** | Most modules accept `extraOptions`, and room defaults use `lib.mkDefault` |

## Module categories

| Category | Modules |
|---|---|
| **Theming** | Catppuccin for GTK, Qt, Plasma, Hyprland, and SDDM |
| **Desktop** | Hyprland (charm-cat and caelestia themes), Niri, GNOME, KDE Plasma configuration |
| **Gaming** | Steam, gale, Heroic, HMCL, AMD GPU |
| **Security** | agenix, impermanence, lanzaboote, YubiKey, GPG |
| **Services** | nginx, PostgreSQL, Forgejo, Gitea, Tailscale, Vaultwarden, Docker, Samba, NFS, ZFS tools, Kubernetes, K3s, monitoring |
| **Dev tools** | VS Code, Cursor, JetBrains, dev-kit (git, nix, rust, go, java, javascript, cpp, lua, wasm, jj, dive), Ollama, Codex |
| **Shell and CLI** | fish, zsh, nushell, direnv, starship, atuin, yazi, neovim, helix |
| **Platform** | NixOS-WSL, Proxmox LXC, nix-darwin, Homebrew |

## Integration modes

The flake exports a module set for each platform:

```nix
# NixOS
imports = [ cattery-modules.nixosModules.default ];

# home-manager
imports = [ cattery-modules.homeModules.default ];

# nix-darwin
imports = [ cattery-modules.darwinModules.default ];
```

## Documentation

| Page | Description |
|---|---|
| [Quick Start](/quick-start) | Setup for NixOS, home-manager, nix-darwin, WSL, and Proxmox LXC |
| [Rooms](/rooms) | Room hierarchy and the modules each room enables |
| [Modules](/modules) | Catalog of modules and their options |
| [Secrets and agenix](/secrets) | Encrypted secret management |
| [Impermanence](/impermanence) | Persist system and home state across reboots |
| [Contributing](/contributing) | Development and contribution guide |

## License

CC0 1.0 Universal
