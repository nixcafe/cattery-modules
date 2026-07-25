# cattery

cattery is a curated collection of **244+ Nix modules** for NixOS, nix-darwin, and home-manager. Choose a **room** — a pre-configured module bundle — enable it, and get a complete system with theming, desktop, gaming, server, dev tools, and more. No boilerplate.

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

One line — full developer desktop with Hyprland, Catppuccin theming, VS Code, JetBrains, Docker, databases, git, shell tools, and more.

***

## What is a Room?

A **room** is a pre-configured bundle of modules with sensible defaults. Enable one room and you get dozens of modules enabled automatically. Each room extends the one below it — enable `desktop.dev` and you get the full chain:

```
room.basis
 ├─ room.general
 ├─ room.server-mini → room.server
 ├─ room.container
 └─ room.desktop.basis
      └─ room.desktop.general
           ├─ room.desktop.dev
           ├─ room.desktop.game
           └─ room.desktop.wsl

room.game  (standalone, not in desktop chain)
```

Rooms use `lib.mkDefault` for all sub-module enables, so you can **override any individual module**:

```nix
cattery.room.desktop.dev.enable = true;
cattery.apps.jetbrains.enable = false;  # I prefer neovim
```

***

## Why cattery?

| Feature | Description |
|---|---|
| **Room-based** | One enable gives you dozens of pre-configured modules |
| **244+ modules** | Covers theming, desktop, gaming, servers, dev, security, secrets |
| **Sensible defaults** | Every module ships with good defaults — override what you need |
| **Cross-platform** | NixOS, nix-darwin, home-manager, NixOS-WSL |
| **agenix secrets** | Built-in encrypted secret management with YubiKey support |
| **Impermanence** | Ephemeral root support with persistent state directories |
| **Extensible** | Compose rooms with `extraModules` from other flakes |

## Module Categories

| Category | Modules | Highlights |
|---|---|---|
| **Theming** | Catppuccin (GTK, Qt, Plasma, Hyprland) | System-wide color scheme |
| **Desktop** | Hyprland, Niri, GNOME, KDE Plasma | Wayland compositors + addons |
| **Gaming** | Steam, GPU (AMD/NVIDIA), launchers | Full gaming setup |
| **Security** | agenix secrets, impermanence, Secure Boot, GPG, YubiKey | Defense in depth |
| **Services** | nginx, PostgreSQL, Forgejo, Tailscale, Vaultwarden, Docker, cloudflared, smartdns | Production-ready |
| **Dev Tools** | VS Code, JetBrains, Git, Rust, Go, Java, JS, Nix, Ollama | Polyglot dev kits |
| **Shell & CLI** | fish, zsh, nushell, direnv, starship, atuin, yazi, neovim, helix | Modern terminal |
| **Platform** | NixOS-WSL, Proxmox LXC, nix-darwin | Everywhere |

## Integration Modes

cattery works everywhere:

```nix
# NixOS (full system)
imports = [ cattery-modules.nixosModules.default ];

# home-manager (user-level)
imports = [ cattery-modules.homeModules.default ];

# nix-darwin (macOS)
imports = [ cattery-modules.darwinModules.default ];
```

## Documentation

| Page | Description |
|---|---|
| [Quick Start](/quick-start) | Full setup guide for NixOS, home-manager, darwin |
| [Rooms](/rooms) | Complete room hierarchy with module listings |
| [Modules](/modules) | Full catalog of all 244+ modules |
| [Secrets & agenix](/secrets) | Encrypted secret management |
| [Contributing](/contributing) | Development guide |

## License

CC0 1.0 Universal
