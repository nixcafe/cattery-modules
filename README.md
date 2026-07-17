# cattery-modules

[![FlakeHub](https://img.shields.io/endpoint?url=https://flakehub.com/f/nixcafe/cattery-modules/badge)](https://flakehub.com/flake/nixcafe/cattery-modules)

A curated collection of Nix modules for **quick-starting NixOS, nix-darwin, and home-manager** configurations. Choose a room, enable it, and get a complete system — no boilerplate.

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
  # One room = a fully configured dev desktop
  cattery.room.desktop.dev.enable = true;
}
```

## Rooms

Rooms are **pre-configured module bundles** — enable one room and get dozens of modules configured with sensible defaults. Each room includes and extends the one below it.

| Room | Description | Includes |
| --- | --- | --- |
| `room.basis` | Base system (nix, git, openssh, locale, fonts) | — |
| `room.general` | General additions (shell, CLI tools, editors) | basis |
| `room.desktop.basis` | Desktop base (display, compositor, theming) | general |
| `room.desktop.general` | Full desktop (apps, services, audio, input) | desktop.basis |
| `room.desktop.dev` | Developer desktop (IDEs, databases, containers) | desktop.general |
| `room.desktop.game` | Gaming desktop (Steam, GPU drivers, Wine) | desktop.general |
| `room.desktop.wsl` | WSL desktop | desktop.basis |
| `room.server-mini` | Lightweight server | basis |
| `room.server` | Full server (docker, nginx, postgres, forgejo) | server-mini |
| `room.container` | Container host (incus, distrobox) | basis |

> Rooms are available for NixOS, home-manager, and nix-darwin. Each room automatically enables its dependency chain — enable `desktop.dev` and you get all of `basis → general → desktop.basis → desktop.general → desktop.dev`.

## Using Individual Modules

You can also enable modules individually:

```nix
cattery.themes.catppuccin.enable = true;
cattery.desktop.hyprland.enable = true;
cattery.services.tailscale.enable = true;
```

## Module Categories

| Category | Highlights |
| --- | --- |
| **Theming** | Catppuccin (GTK, Qt, Plasma, Hyprland), SDDM themes |
| **Desktop** | Hyprland, Niri, GNOME, KDE Plasma |
| **Gaming** | Steam, GPU drivers (AMD/NVIDIA), RetroArch |
| **Security** | agenix secrets, impermanence (ephemeral root), Secure Boot (lanzaboote) |
| **Services** | nginx, PostgreSQL, Forgejo, Tailscale, Vaultwarden, Docker |
| **Dev** | VS Code Server, JetBrains, dev-kit (git, nix, shell tools) |
| **Platform** | NixOS-WSL, nix-darwin, Proxmox LXC |

## Development

```bash
nix develop     # enter dev shell with nixfmt, deadnix, statix
nix flake check # lint + eval all modules
nix fmt         # format all files
```

This project follows [GitHub Flow](https://docs.github.com/en/get-started/using-github/github-flow). Branch prefix: `feat/`, `fix/`, `chore/`, `docs/`. All PRs require one approving review and passing CI.

## License

[CC0 1.0 Universal](LICENSE)
