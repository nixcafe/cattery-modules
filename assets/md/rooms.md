# Rooms

A room is a module that enables other modules with `lib.mkDefault`. Enabling one room enables its dependencies, so a single option can turn on a set of related features. All sub-module enables use `lib.mkDefault`, so explicit settings take precedence.

The NixOS room graph:

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

Home-manager has a separate chain and a standalone `room.game`. nix-darwin provides `room.basis` and `room.desktop.dev`.

## How rooms work

Rooms exist in the NixOS, home-manager, and nix-darwin module sets. The NixOS set has the largest graph. The home-manager set has its own chain, and the darwin set has only two rooms. Enabling `desktop.dev` in the NixOS set enables `desktop.general`, then `desktop.basis`, then `basis`.

To override a room, set the individual module option. The room default loses because `lib.mkDefault` has a lower priority than a normal assignment:

```nix
cattery.room.desktop.dev.enable = true;
cattery.apps.jetbrains.enable = false;
```

## NixOS rooms

### room.basis

The base system. It enables `cli-apps.mtr`, `cli-apps.nix.nix-ld`, `services.cron`, `services.openssh`, `system.locale`, `system.network`, `system.time`, and `system.ulimit`. It also enables `nix` and `cli-apps.openssh`, and sets `system.boot.kernel.useLatest` to `true`.

```nix
cattery.room.basis.enable = true;
```

### room.general

`room.basis` plus `system.boot.efi`.

```nix
cattery.room.general.enable = true;
```

### room.server-mini

`room.basis` plus `services.acme`. It also exposes `qemu-guest.enable` and `cloud-init.enable`. Both are off by default.

```nix
cattery.room.server-mini.enable = true;
cattery.room.server-mini.qemu-guest.enable = true;
cattery.room.server-mini.cloud-init.enable = true;
```

### room.server

`room.basis` plus `room.server-mini`. The `qemu-guest` and `cloud-init` options are passed through to `server-mini`.

```nix
cattery.room.server = {
  enable = true;
  qemu-guest.enable = true;
  cloud-init.enable = true;
};
```

### room.server.nas

`room.server` plus a set of storage and monitoring services. `samba`, `avahi`, `samba-wsdd`, `sanoid`, `syncoid`, `beszel`, `nfs`, and `target` are enabled by default. `netdata` and `zfs` are available but off by default. `zfs` requires `networking.hostId`.

```nix
cattery.room.server.nas = {
  enable = true;
  zfs.enable = true;
  netdata.enable = false;
};
```

### room.container

`room.basis` plus `services.acme`. It sets `boot.isContainer = true` and disables `wpa_supplicant`, which cannot start in a container without `/dev/rfkill`.

```nix
cattery.room.container.enable = true;
```

### room.desktop.basis

`room.basis` plus `system.automount`, `system.fcitx5`, `system.network.wireless`, `system.peripherals`, `desktop.addons.chromium-support`, `cli-apps.security.fido2`, and `system.fonts`.

```nix
cattery.room.desktop.basis.enable = true;
```

### room.desktop.general

`room.desktop.basis` plus `system.boot.efi`.

```nix
cattery.room.desktop.general.enable = true;
```

### room.desktop.dev

`room.desktop.general` plus `apps.yubikey`, `services.docker`, `services.vscode-server`, and `system.boot.binfmt`. It also sets `security.sudo.wheelNeedsPassword = false`.

```nix
cattery.room.desktop.dev.enable = true;
```

### room.desktop.game

`room.desktop.general` plus `apps.game.steam`. It also sets `security.sudo.wheelNeedsPassword = false`.

```nix
cattery.room.desktop.game.enable = true;
```

### room.desktop.wsl

`room.desktop.basis` plus `system.wsl`. It also sets `security.sudo.wheelNeedsPassword = false`.

```nix
cattery.room.desktop.wsl.enable = true;
```

## Home-manager rooms

### room.basis

Enables `cli-apps.dev-kit.git`, `cli-apps.dev-kit.nix`, `cli-apps.tool.gh`, `cli-apps.nix.home-manager`, and `cli-apps.nix.nix-index`.

```nix
cattery.room.basis.enable = true;
```

### room.general

`room.basis` plus shell and CLI tools: `cli-apps.shell.atuin`, `direnv`, `starship`, and `powershell` (Darwin). It also enables `cli-apps.tool.http-utils`, `monitoring`, `network`, `compressor`, `tldr`, and `misc`, sets `cli-apps.tool.useful` with `commonAliases`, and enables `cli-apps.file-manager.yazi`, `cli-apps.disk`, and `cli-apps.misc`.

```nix
cattery.room.general.enable = true;
```

### room.game

Standalone room based on `room.basis`. It enables `apps.vscode`, `apps.zed-editor`, `apps.instant-messengers`, `cli-apps.video.visual`, and `cli-apps.video.youtube`. On Linux it also enables `apps.game`; on Darwin it enables `apps.iina`.

```nix
cattery.room.game.enable = true;
```

### room.server-mini

`room.basis` plus `cli-apps.shell.starship`. It sets `system.impermanence.xdg.userDirs.enable` to `false` by default.

```nix
cattery.room.server-mini.enable = true;
```

### room.server

`room.general` plus `room.server-mini` plus `cli-apps.tool.acme-sh`.

```nix
cattery.room.server.enable = true;
```

### room.container

`room.basis` plus `cli-apps.shell.starship` and `cli-apps.tool.acme-sh`.

```nix
cattery.room.container.enable = true;
```

### room.desktop.basis

`room.general` plus `apps.graphics`, `apps.useful`, and `desktop.xdg`.

```nix
cattery.room.desktop.basis.enable = true;
```

### room.desktop.general

`room.desktop.basis` plus `apps.wezterm`, `apps.vscode`, and `apps.zed-editor` (with `defaultEditor` enabled). On Linux it also enables `apps.browser`.

```nix
cattery.room.desktop.general.enable = true;
```

### room.desktop.dev

`room.desktop.general` plus `apps.instant-messengers`, `apps.jetbrains`, `apps.code-cursor`, `cli-apps.database.sqlite`, `cli-apps.operations.cloud`, `cli-apps.operations.kubernetes`, `cli-apps.security.gnupg`, and `cli-apps.tool.ollama`. It also enables `cli-apps.video.visual` and `cli-apps.video.youtube`.

On Linux it enables `apps.thunderbird`, `apps.science`, `apps.video`, `cli-apps.cloudflared`, and `cli-apps.warp`. On Darwin it enables `apps.iina` and `cli-apps.android`.

The `allDevKit` option enables `cli-apps.dev-kit.cpp`, `dive`, `go`, `java` (with Maven and Gradle), `javascript`, `lua`, `rust`, and `wasm`.

```nix
cattery.room.desktop.dev = {
  enable = true;
  allDevKit = true;
};
```

### room.desktop.game

`room.desktop.general` plus `apps.instant-messengers`. On Linux it also enables `apps.game`.

```nix
cattery.room.desktop.game.enable = true;
```

### room.desktop.wsl

`room.desktop.basis` only.

```nix
cattery.room.desktop.wsl.enable = true;
```

### room.server.nas

`room.server` plus `cli-apps.tool.useful` and `cli-apps.disk`.

```nix
cattery.room.server.nas.enable = true;
```

## nix-darwin rooms

### room.basis

Enables `brew`, `system.sudoTouch`, `system.useful`, `nix`, `cli-apps.openssh`, `system.fonts`, and `system.ulimit` with `openFilesLimit = 4096`.

```nix
cattery.room.basis.enable = true;
```

### room.desktop.dev

`room.basis` plus `cli-apps.security.fido2`.

```nix
cattery.room.desktop.dev.enable = true;
```

## Customizing rooms

All rooms use `lib.mkDefault` for sub-module enables, so explicit configuration wins:

```nix
cattery.room.desktop.dev.enable = true;

cattery.desktop.hyprland.enable = false;
cattery.desktop.niri.enable = true;          # use niri
cattery.apps.jetbrains.enable = false;        # use neovim
cattery.cli-apps.shell.fish.enable = false;
cattery.cli-apps.shell.zsh.enable = true;
```

The login shell modules also read `cattery.user.defaultUserShell`. Setting that to `pkgs.fish`, `pkgs.zsh`, or `pkgs.nushell` enables the matching module by default.

## Composing multiple rooms

Rooms can be enabled together. Shared dependencies are enabled once, and each room adds its own modules:

```nix
cattery = {
  room.desktop.dev.enable = true;
  room.desktop.game.enable = true;
};
```

## Rooms compared with individual modules

| Approach | Use when |
|---|---|
| Room | You want a working set of related modules with defaults to override |
| Individual modules | You want to choose every module yourself |

You can start with a room and then disable or add individual modules.
