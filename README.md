<h1 align="center">cattery-modules</h1>
<p align="center">
  Nix modules for NixOS, home-manager, and nix-darwin. Enable a room to configure a system, or pick individual modules.
  <br />
  <a href="https://cattery.nixcafe.org"><strong>cattery.nixcafe.org</strong></a>
</p>

<p align="center">
  <a href="https://flakehub.com/flake/nixcafe/cattery-modules"><img src="https://img.shields.io/endpoint?url=https://flakehub.com/f/nixcafe/cattery-modules/badge" alt="FlakeHub" /></a>
  <a href="https://github.com/nixcafe/cattery-modules/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-CC0--1.0-brightgreen" alt="License" /></a>
</p>

---

## Quick start

Add the flake input and import the default NixOS module:

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

Then enable a room:

```nix
# configuration.nix
{ ... }: {
  cattery.room.desktop.dev.enable = true;
}
```

This enables the NixOS side of the room. The same room names exist in home-manager for user packages. Import `cattery-modules.homeModules.default` in your home-manager configuration and enable the room there as well:

```nix
# home-manager configuration, with inputs passed through extraSpecialArgs
{ inputs, ... }: {
  imports = [ inputs.cattery-modules.homeModules.default ];

  cattery.room.desktop.dev.enable = true;
}
```

Rooms enable their submodules with `lib.mkDefault`, so individual settings override the room defaults.

## What is cattery?

cattery-modules is a Nix flake that provides the `cattery` option namespace. It works with NixOS, home-manager, and nix-darwin, and includes modules for NixOS-WSL and Proxmox LXC.

Rooms are bundles of modules. You can enable a room and use its defaults, or enable individual modules under the same namespace. The `modules/` tree currently contains 262 Nix module files, including room definitions and secret helpers. `nix flake check` evaluates all of them.

## Room hierarchy

NixOS rooms:

```
room.basis
├─ room.general (basis + EFI boot)
├─ room.container (basis + ACME, container boot)
├─ room.server-mini (basis + ACME, optional cloud-init and qemu-guest)
│  └─ room.server (basis + server-mini)
│     └─ room.server.nas (server + Samba, NFS, optional ZFS, sanoid, syncoid, Beszel, netdata, iSCSI target)
└─ room.desktop.basis (basis + automount, fcitx5, wireless, peripherals, fonts, FIDO2)
   ├─ room.desktop.general (desktop.basis + EFI boot)
   │  ├─ room.desktop.dev (desktop.general + Docker, VS Code server, YubiKey, binfmt)
   │  └─ room.desktop.game (desktop.general + Steam)
   └─ room.desktop.wsl (desktop.basis + WSL)
```

home-manager rooms:

```
room.basis
├─ room.general (basis + shells and CLI tools)
├─ room.container (basis + starship, acme-sh)
├─ room.server-mini (basis + starship)
│  └─ room.server (general + server-mini + acme-sh)
│     └─ room.server.nas (server + disk tools)
├─ room.desktop.basis (general + graphics, useful apps, XDG)
│  ├─ room.desktop.general (desktop.basis + terminals, editors, browser)
│  │  ├─ room.desktop.dev (desktop.general + JetBrains, dev kits, CLI tools)
│  │  └─ room.desktop.game (desktop.general + messengers, game apps)
│  └─ room.desktop.wsl (desktop.basis)
└─ room.game (basis + editors, messengers, video, game apps)
```

nix-darwin rooms:

```
room.basis
└─ room.desktop.dev (basis + FIDO2)
```

## Features

- Rooms bundle related modules and enable them with `lib.mkDefault`.
- Modules for NixOS, home-manager, and nix-darwin, plus platform modules for NixOS-WSL and Proxmox LXC.
- Theming, desktop, gaming, server, development, shell, security, and secret-management modules.
- agenix helpers for services such as nginx, PostgreSQL, Forgejo, WireGuard, and cloudflared.
- Impermanence support for NixOS and home-manager, including XDG user directories and the Projects directory.
- Modules that wrap another service or program often expose an `extraOptions` attribute for configuration that is merged into the wrapped module.

## Module categories

| Category | Highlights |
|---|---|
| **Theming** | Catppuccin for NixOS and home-manager, plus charm-cat and caelestia Hyprland themes |
| **Desktop** | Hyprland, Niri, GNOME, KDE Plasma, LightDM |
| **Gaming** | Steam, Gale, AMD GPU, PipeWire low-latency |
| **Security** | agenix, impermanence, Secure Boot (lanzaboote), YubiKey, GPG |
| **Services** | nginx, PostgreSQL, Forgejo, Gitea, Tailscale, Vaultwarden, Docker, Kubernetes, K3s |
| **Dev tools** | VS Code, JetBrains, Ollama, and dev kits for C++, Go, Java, JavaScript, Lua, Nix, Rust, and WebAssembly |
| **Shell and CLI** | fish, zsh, nushell, direnv, starship, atuin, yazi, neovim, helix |
| **Platform** | NixOS-WSL, Proxmox LXC, nix-darwin |

## Picking individual modules

In a NixOS module:

```nix
cattery = {
  desktop.addons.catppuccin.enable = true;
  desktop.hyprland.enable = true;
  services.tailscale.enable = true;
};
```

In a home-manager module:

```nix
cattery = {
  desktop.addons.catppuccin.enable = true;
  desktop.hyprland.enable = true;
  cli-apps.dev-kit.git.enable = true;
  cli-apps.dev-kit.rust.enable = true;
};
```

## Customizing rooms

Room submodules are enabled with `lib.mkDefault`, so your overrides take precedence. This example is for a home-manager module:

```nix
cattery.room.desktop.dev.enable = true;
cattery.apps.jetbrains.enable = false;    # use another IDE instead
cattery.desktop.hyprland.enable = false;  # use Niri instead
cattery.desktop.niri.enable = true;
```

## Development

```bash
nix develop     # dev shell with nixfmt, deadnix, statix
nix flake check # run pre-commit hooks and evaluate every module file
nix fmt         # format Nix files
```

## Documentation

Documentation for the module catalog, rooms, secrets, and contributing is at [cattery.nixcafe.org](https://cattery.nixcafe.org).

## License

[CC0 1.0 Universal](LICENSE)
