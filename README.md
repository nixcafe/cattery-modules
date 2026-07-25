<h1 align="center">cattery-modules</h1>
<p align="center">
  A curated collection of <strong>244+ Nix modules</strong> — choose a room, enable it, and get a complete system with theming, desktop, gaming, server, dev tools, and more.
  <br />
  <a href="https://cattery.nixcafe.org"><strong>cattery.nixcafe.org</strong></a>
</p>

<p align="center">
  <a href="https://flakehub.com/flake/nixcafe/cattery-modules"><img src="https://img.shields.io/endpoint?url=https://flakehub.com/f/nixcafe/cattery-modules/badge" alt="FlakeHub" /></a>
  <a href="https://github.com/nixcafe/cattery-modules/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-CC0--1.0-brightgreen" alt="License" /></a>
</p>

---

## Quick Start

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

One line — full developer desktop. `nixos-rebuild switch`, done.

## What is cattery?

cattery provides **rooms** (pre-configured module bundles) and **244+ individual modules** for NixOS, nix-darwin, home-manager, and NixOS-WSL. Enable a room and get dozens of modules with sensible defaults. Override anything you want.

```
room.basis                          # mtr, nix-ld, cron, openssh, locale, network, time, kernel
 └─ room.general                    # basis + boot.efi
     ├─ room.server-mini            # basis + cloud-init, qemu-guest, acme
     │   └─ room.server             # basis + server-mini (passthrough)
     ├─ room.container              # basis + acme, boot.isContainer
     └─ room.desktop.basis          # basis + automount, wireless, peripherals, fonts, fcitx5
          └─ room.desktop.general   # desktop.basis + boot.efi
               ├─ room.desktop.dev  # desktop.general + yubikey, docker, vscode-server
               ├─ room.desktop.game # desktop.general + steam
               └─ room.desktop.wsl  # desktop.basis + wsl

room.game                           # standalone (home-manager): basis + vscode, zed, messengers, video
```

## Features

- **244+ modules** — theming, desktop, gaming, servers, dev tools, security, secrets
- **Room-based quick start** — one enable gives you a fully configured system
- **agenix secrets** — encrypted configs for nginx, postgres, forgejo, wireguard, cloudflared, and more
- **Impermanence** — ephemeral root with persistent state directories
- **Cross-platform** — NixOS, nix-darwin, home-manager, NixOS-WSL, Proxmox LXC
- **Extensible** — every module accepts `extraOptions`, every room uses `mkDefault`

## Module Categories

| Category | Highlights |
|---|---|
| **Theming** | Catppuccin (GTK, Qt, Plasma, Hyprland, SDDM) |
| **Desktop** | Hyprland (charm-cat & caelestia themes), Niri, GNOME, KDE Plasma |
| **Gaming** | Steam, AMD GPU, game launchers |
| **Security** | agenix, impermanence, Secure Boot (lanzaboote), YubiKey, GPG |
| **Services** | nginx, PostgreSQL, Forgejo, Gitea, Tailscale, Vaultwarden, Docker |
| **Dev Tools** | VS Code, JetBrains, all dev-kits (git, rust, go, java, js, cpp, lua, wasm), Ollama |
| **Shell & CLI** | fish, zsh, nushell, direnv, starship, atuin, yazi, neovim, helix |
| **Platform** | NixOS-WSL, Proxmox LXC, nix-darwin |

## Picking Individual Modules

```nix
cattery = {
  themes.catppuccin.enable = true;
  desktop.hyprland.enable = true;
  services.tailscale.enable = true;
  cli-apps.dev-kit.git.enable = true;
  cli-apps.dev-kit.rust.enable = true;
};
```

## Customizing Rooms

All sub-module enables use `lib.mkDefault` — your overrides always win:

```nix
cattery.room.desktop.dev.enable = true;
cattery.apps.jetbrains.enable = false;       # I prefer neovim
cattery.desktop.hyprland.enable = false;     # I prefer Niri
cattery.desktop.niri.enable = true;
```

## Development

```bash
nix develop     # enter dev shell (nixfmt, deadnix, statix)
nix flake check # lint + eval all 244+ modules
nix fmt         # format all files
```

## Documentation

Full documentation at **[cattery.nixcafe.org](https://cattery.nixcafe.org)** — quick start, room hierarchy, full module catalog, secrets guide, and contributing.

## License

[CC0 1.0 Universal](LICENSE)
