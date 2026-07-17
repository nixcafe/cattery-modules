# Modules

Every module lives under the `cattery` namespace. Enable them individually or let rooms compose them for you.

## Module Categories

### Theming

| Module | Description |
| --- | --- |
| `themes.catppuccin` | Catppuccin color scheme for GTK, Qt, Hyprland, Plasma |

### Desktop

| Module | Description |
| --- | --- |
| `desktop.hyprland` | Hyprland Wayland compositor |
| `desktop.niri` | Niri scrollable-tiling compositor |
| `desktop.plasma` | KDE Plasma desktop |
| `desktop.gnome` | GNOME desktop |
| `desktop.addons.catppuccin` | Catppuccin for desktop addons |
| `desktop.addons.xdg-portal` | XDG Desktop Portal setup |

### Gaming

| Module | Description |
| --- | --- |
| `gaming.steam` | Steam client with dependencies |
| `system.gpu.amd` | AMD GPU drivers & configuration |
| `system.gpu.nvidia` | NVIDIA GPU drivers & configuration |

### Security

| Module | Description |
| --- | --- |
| `secrets.agenix` | Encrypted secrets via agenix |
| `system.impermanence` | Ephemeral root with persistent directories |
| `desktop.hyprland.theme.caelestia` | Hyprland Catppuccin theme |

### Services

| Module | Description |
| --- | --- |
| `services.tailscale` | Tailscale mesh VPN |
| `services.nginx` | Nginx web server |
| `services.postgresql` | PostgreSQL database |
| `services.forgejo` | Forgejo git forge |
| `services.docker` | Docker container runtime |
| `services.vaultwarden` | Vaultwarden password manager |
| `services.openssh` | OpenSSH server |
| `services.cloudflared` | Cloudflare Tunnel |
| `services.smartdns` | SmartDNS proxy |

### Dev Tools

| Module | Description |
| --- | --- |
| `cli-apps.dev-kit.git` | Git configuration |
| `cli-apps.dev-kit.nix` | Nix configuration & aliases |
| `cli-apps.editor.vscode` | VS Code |
| `cli-apps.editor.jetbrains` | JetBrains IDEs |
| `cli-apps.nix.home-manager` | home-manager integration |
| `services.vscode-server` | VS Code remote server |

### Shell & CLI

| Module | Description |
| --- | --- |
| `cli-apps.shell.fish` | Fish shell |
| `cli-apps.shell.zsh` | Zsh shell |
| `cli-apps.tool.gh` | GitHub CLI |
| `cli-apps.file-manager.yazi` | Yazi terminal file manager |

### Platform

| Module | Description |
| --- | --- |
| `system.wsl` | NixOS-WSL integration |
| `system.proxmox.lxc` | Proxmox LXC container support |
| `system.boot.lanzaboote` | Secure Boot with lanzaboote |

> Module list is incomplete — more modules are being added. See the [repository](https://github.com/nixcafe/cattery-modules/tree/main/modules) for the full list.
