# Rooms

Rooms are **pre-configured module bundles**. Enable one room and dozens of modules activate with sensible defaults. Each room includes the one below it — rooms form a **dependency chain**.

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
```

## How Rooms Work

Rooms are available for NixOS, home-manager, and nix-darwin. Each room auto-enables its dependency chain — enable `desktop.dev` and you get all of `basis → general → desktop.basis → desktop.general → desktop.dev`.

All sub-module enables use `lib.mkDefault`, so you can **override any individual module**:

```nix
cattery.room.desktop.dev.enable = true;
# Still get everything except the stuff you opt out of:
cattery.apps.jetbrains.enable = false;
cattery.desktop.plasma.enable = false;
```

## NixOS Rooms

### `room.basis` — Essential System

The foundation. Every other room builds on this.

**Enables:** mtr, nix-ld, cron, openssh, locale, network, time, kernel, nix, cli-apps.openssh, ulimit

```nix
cattery.room.basis.enable = true;
```

### `room.general` — Everyday System

Basis + boot setup.

**Enables:** basis + boot.efi

```nix
cattery.room.general.enable = true;
```

### `room.server-mini` — Lightweight Server

Basis + cloud-friendly additions.

**Enables:** basis + cloud-init, qemu-guest, acme

```nix
cattery.room.server-mini.enable = true;
cattery.room.server-mini.qemu-guest.enable = true;   # optional
cattery.room.server-mini.cloud-init.enable = true;   # optional
```

### `room.server` — Full Server

Basis + server-mini with passthrough options.

**Enables:** basis + server-mini (inherits qemu-guest/cloud-init passthrough)

```nix
cattery.room.server = {
  enable = true;
  qemu-guest.enable = true;
  cloud-init.enable = true;
};
```

### `room.container` — Container Host

Basis optimized for containers.

**Enables:** basis + acme, `boot.isContainer = true`

```nix
cattery.room.container.enable = true;
```

### `room.desktop.basis` — Desktop Base

Basis + display foundation.

**Enables:** basis + automount, fcitx5, wireless, peripherals, chromium-support, fido2, fonts

```nix
cattery.room.desktop.basis.enable = true;
```

### `room.desktop.general` — Full Desktop

Desktop basis + boot.

**Enables:** desktop.basis + boot.efi

```nix
cattery.room.desktop.general.enable = true;
```

### `room.desktop.dev` — Developer Desktop

Full desktop + dev tools. The most common room for developers.

**Enables:** desktop.general + yubikey, docker, vscode-server, binfmt (aarch64 emulation)

Also sets `security.sudo.wheelNeedsPassword = false` (passwordless sudo).

```nix
cattery.room.desktop.dev.enable = true;
```

### `room.desktop.game` — Gaming Desktop

Full desktop + gaming.

**Enables:** desktop.general + steam

Also sets `security.sudo.wheelNeedsPassword = false`.

```nix
cattery.room.desktop.game.enable = true;
```

### `room.desktop.wsl` — WSL Desktop

Desktop basis + WSL integration.

**Enables:** desktop.basis + wsl

Also sets `security.sudo.wheelNeedsPassword = false`.

```nix
cattery.room.desktop.wsl.enable = true;
```

## Home-Manager Rooms

### `room.basis`

Essential CLI tools.

**Enables:** git, nix (dev-kit), gh, home-manager, nix-index

```nix
cattery.room.basis.enable = true;
```

### `room.general`

Basis + everyday shell tools.

**Enables:** basis + atuin, direnv, starship, powershell, http-utils, monitoring, network, compressor, useful (aliases), tldr, misc, yazi, disk, misc(linux)

```nix
cattery.room.general.enable = true;
```

### `room.game`

Basis + gaming-oriented apps. Standalone (not in the desktop chain).

**Enables:** basis + vscode, zed-editor, instant-messengers, video (visual + youtube), apps.game (Linux), iina (Darwin)

```nix
cattery.room.game.enable = true;
```

### `room.server-mini`

Basis + prompt.

**Enables:** basis + starship

### `room.server`

General + server-mini + acme-sh.

### `room.container`

Basis + starship + acme-sh.

### `room.desktop.basis`

General + GUI apps.

**Enables:** general + apps.graphics, apps.useful, desktop.xdg

### `room.desktop.general`

Desktop basis + editors + browser.

**Enables:** desktop.basis + wezterm, vscode, zed-editor, browser

### `room.desktop.dev`

Full developer setup — IDEs, databases, all dev kits, cloud tools.

| Option | Description |
|---|---|
| `allDevKit` | Enable all dev-kit sub-modules (cpp, go, java, javascript, lua, rust, wasm) |

**Enables:** desktop.general + instant-messengers, jetbrains, code-cursor, sqlite, dev-kits (optional via `allDevKit`), cloud, kubernetes, gnupg, ollama, thunderbird(linux), science(linux), video(linux), cloudflared(linux), warp(linux), iina(darwin), android(darwin)

```nix
cattery.room.desktop.dev = {
  enable = true;
  allDevKit = true;   # enable all dev-kits
};
```

### `room.desktop.game`

Desktop general + gaming.

**Enables:** desktop.general + instant-messengers, game

### `room.desktop.wsl`

Desktop basis only.

## Darwin Rooms

### `room.basis`

macOS essentials.

**Enables:** brew, system.sudoTouch, system.useful, nix, cli-apps.openssh, system.fonts, system.ulimit (openFilesLimit=4096)

### `room.desktop.dev`

Basis + fido2.

**Enables:** basis + cli-apps.security.fido2

## Customizing Rooms

All rooms use `lib.mkDefault` for sub-module enables. Your explicit config always wins:

```nix
cattery.room.desktop.dev.enable = true;

# Disable individual modules from the room:
cattery.desktop.hyprland.enable = false;
cattery.desktop.niri.enable = true;           # prefer niri
cattery.apps.jetbrains.enable = false;         # prefer neovim
cattery.cli-apps.shell.fish.enable = false;    # prefer zsh
cattery.cli-apps.shell.zsh.enable = true;
```

## Composing Multiple Rooms

You can enable multiple rooms simultaneously (later rooms override defaults from earlier ones):

```nix
cattery = {
  room.desktop.dev.enable = true;    # gets developer tools
  room.desktop.game.enable = true;   # adds steam + gaming
};
```

## Room vs Individual Modules

| Approach | When to use |
|---|---|
| **Room** | Quick start, new machines, want sensible defaults for an entire category |
| **Individual modules** | Fine-grained control, building from scratch, specific needs |

You can mix both — start with a room, then disable or add individual modules as needed.
