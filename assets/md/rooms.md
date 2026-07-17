# Rooms

Rooms are **pre-configured module bundles**. Enable one room and get dozens of modules with sensible defaults. Each room includes and extends the one below it.

## Room Hierarchy

```
room.basis
 └─ room.general
     ├─ room.server-mini
     │   └─ room.server
     ├─ room.container
     └─ room.desktop.basis
          └─ room.desktop.general
               ├─ room.desktop.dev
               ├─ room.desktop.game
               └─ room.desktop.wsl
```

## Available Rooms

### Base Rooms

| Room | Description | Key Modules |
| --- | --- | --- |
| `room.basis` | Essential system setup | nix, git, openssh, locale, fonts, network |
| `room.general` | Everyday additions | shell (fish/zsh), CLI tools, editors, file manager |

### Server Rooms

| Room | Description | Key Modules |
| --- | --- | --- |
| `room.server-mini` | Lightweight server | openssh, tailscale, firewall |
| `room.server` | Full server | docker, nginx, postgresql, forgejo, vaultwarden, qemu-guest |
| `room.container` | Container host | incus, distrobox |

### Desktop Rooms

| Room | Description | Key Modules |
| --- | --- | --- |
| `room.desktop.basis` | Desktop base | display manager, compositor (hyprland/niri/plasma), Catppuccin theming |
| `room.desktop.general` | Full desktop | audio (pipewire), input, fonts, apps (browser, mail, etc.) |
| `room.desktop.dev` | Developer desktop | IDEs (vscode/jetbrains), databases, dev-kit, containers |
| `room.desktop.game` | Gaming desktop | Steam, GPU drivers (AMD/NVIDIA), Wine, RetroArch |
| `room.desktop.wsl` | WSL desktop | WSL-optimized desktop with GPU integration |

## Customizing Rooms

Rooms use `lib.mkDefault` for sub-module enables, so you can opt out of any individual module:

```nix
cattery.room.desktop.game.enable = true;
# Still get everything except JetBrains
cattery.cli-apps.editor.jetbrains.enable = false;
```
