# Modules

cattery provides **244+ modules** under the `cattery` namespace. Enable them individually or let rooms compose them for you.

## Theming

### `cattery.themes.catppuccin`

Catppuccin color scheme system-wide. Applies to GTK, Qt, Hyprland, Plasma, and SDDM.

```nix
cattery.themes.catppuccin.enable = true;
```

## Desktop

### Compositors

| Module | Description | Options |
|---|---|---|
| `cattery.desktop.hyprland` | Hyprland Wayland compositor with XWayland | `enable` |
| `cattery.desktop.niri` | Niri scrollable-tiling compositor | `enable`, `configText`, `include`, `spawnAtStartup`, `binds` |
| `cattery.desktop.plasma` | KDE Plasma 6 with SDDM | `enable`, `useConnect`, `persistence` |
| `cattery.desktop.gnome` | GNOME desktop with GDM | `enable` |

### Hyprland Themes

| Module | Description | Options |
|---|---|---|
| `cattery.desktop.hyprland.theme.charm-cat` | Full Hyprland rice — waybar, kitty, anyrun, hyprlock, mako, wlogout, awww wallpaper | `enable`, `greetd.enable` |
| `cattery.desktop.hyprland.theme.caelestia` | Caelestia dots with SDDM — kitty, thunar, hyprshot, hypridle | `enable`, `settings` |

### Charm-Cat Theme Sub-modules

| Module | Description |
|---|---|
| `cattery.desktop.hyprland.theme.charm-cat.audio` | pipewire, wireplumber, pavucontrol, brightnessctl |
| `cattery.desktop.hyprland.theme.charm-cat.convention` | Workspace conventions, keybinds, monitor rules |
| `cattery.desktop.hyprland.theme.charm-cat.fcitx` | Fcitx5 input method integration |
| `cattery.desktop.hyprland.theme.charm-cat.file-manager` | Dolphin file manager |
| `cattery.desktop.hyprland.theme.charm-cat.launcher` | Anyrun with plugins (applications, symbols, shell, rink, kidex, websearch) |
| `cattery.desktop.hyprland.theme.charm-cat.lock-screen` | Hyprlock + hypridle screen lock |
| `cattery.desktop.hyprland.theme.charm-cat.notification` | Mako notification daemon |
| `cattery.desktop.hyprland.theme.charm-cat.screenshots` | Hyprshot + grim + slurp + wl-clipboard |
| `cattery.desktop.hyprland.theme.charm-cat.terminal` | Kitty with JetBrains Mono Nerd Font + extensive keybinds |
| `cattery.desktop.hyprland.theme.charm-cat.vscode` | VS Code workspace integration |
| `cattery.desktop.hyprland.theme.charm-cat.wallpaper` | Awww wallpaper rotation |
| `cattery.desktop.hyprland.theme.charm-cat.waybar` | Waybar with JSON config |
| `cattery.desktop.hyprland.theme.charm-cat.wlogout` | Wlogout power menu |

### Caelestia Theme Sub-modules

| Module | Description |
|---|---|
| `cattery.desktop.hyprland.theme.caelestia.convention` | Rich settings, wsaction script, workspace switching |
| `cattery.desktop.hyprland.theme.caelestia.audio` | pipewire, wireplumber, pavucontrol, brightnessctl |
| `cattery.desktop.hyprland.theme.caelestia.fcitx` | Fcitx5 integration |
| `cattery.desktop.hyprland.theme.caelestia.file-manager` | Thunar with archive & volume plugins |
| `cattery.desktop.hyprland.theme.caelestia.idle` | Hypridle + caelestia shell lock |
| `cattery.desktop.hyprland.theme.caelestia.screenshots` | Hyprshot screenshot tool |
| `cattery.desktop.hyprland.theme.caelestia.terminal` | Kitty with JetBrains Mono Nerd Font |

### Desktop Addons

| Module | Description | Options |
|---|---|---|
| `cattery.desktop.addons.catppuccin` | Catppuccin for desktop environment | `enable`, `autoEnable`, `extraOptions` |
| `cattery.desktop.addons.xdg-portal` | XDG Desktop Portal with wlr | `enable` |
| `cattery.desktop.addons.chromium-support` | Wayland Chromium/Electron (NIXOS\_OZONE\_WL=1) | `enable` |
| `cattery.desktop.xdg` | MIME default apps (browser, editor, audio, video, mail, calendar) | `app.browser`, `app.editor`, `app.audio`, `app.video`, `app.mailto`, `app.calendar` |

### Hyprland Addons

| Module | Description |
|---|---|
| `cattery.desktop.hyprland.addons.hyprshot` | Screenshot tool (hyprshot + grim + slurp) |
| `cattery.desktop.hyprland.addons.hyprlock` | Screen locker |
| `cattery.desktop.hyprland.addons.hypridle` | Idle management daemon |

### Display Managers

| Module | Description | Options |
|---|---|---|
| `cattery.desktop.lightdm` | LightDM with X server | `enable` |

## Gaming

| Module | Description | Options |
|---|---|---|
| `cattery.apps.game.steam` | Steam with protonup-qt, remote play, hardware support | `enable`, `persistence` |
| `cattery.apps.game.gale` | Gale game launcher | `enable`, `persistence` |
| `cattery.apps.game` | Heroic Games Launcher (Epic/GOG), r2modman | `enable` |
| `cattery.apps.hmcl` | HMCL Minecraft launcher | `enable`, `persistence` |
| `cattery.system.gpu.amd` | AMD GPU drivers (amdgpu kernel module) | `enable` |

## Security

### Secrets (agenix)

See the [Secrets & agenix](/secrets) page for full documentation.

| Module | Description | Options |
|---|---|---|
| `cattery.secrets` | agenix encrypted secrets — host-specific, shared, and user scope | `enable`, `yubikey.enable`, `secretsDir`, `secretsMountPoint`, `hosts`, `shared`, `files` |
| `cattery.nix.secrets` | Encrypted nix config via agenix | `enable`, encrypted `!include` path |

### Impermanence

| Module | Description | Options |
|---|---|---|
| `cattery.system.impermanence` | Ephemeral root with persistent state (NixOS) | `enable`, `directories`, `files`, `persistencePath` |
| `cattery.system.impermanence` (home) | Ephemeral root (home-manager) | `enable`, `directories`, `files`, `xdg.userDirs`, `xdg.cache`, `xdg.config`, `xdg.data`, `xdg.state` |
| `cattery.system.fileSystems.btrfs.impermanence` | BTRFS subvolume rolling for impermanence | `device`, `tempDir`, `oldSubvolDir`, `subvol` per filesystem |

### Secure Boot

| Module | Description | Options |
|---|---|---|
| `cattery.system.boot.lanzaboote` | Secure Boot with lanzaboote | `enable`, `pkiBundle`, `extraOptions` |

### Other Security

| Module | Description | Options |
|---|---|---|
| `cattery.security.pam` | PAM configuration passthrough | Attrs passthrough |
| `cattery.apps.yubikey` | YubiKey with yubikey-agent, touch-detector, pcscd | `enable`, `agent.enable`, `touch-detector.enable` |
| `cattery.apps.safety` | Bitwarden desktop | `enable` |

## Services

### Web & Reverse Proxy

| Module | Description | Options |
|---|---|---|
| `cattery.services.nginx` | Nginx with conf.d includes | `enable`, `httpSubConfigPath`, `commonHttpConfig`, `httpConfig`, `appendHttpConfig`, `virtualHosts`, `preStart`, `extraOptions` |
| `cattery.services.nginx.secrets` | Encrypted nginx conf.d via agenix | Auto-enabled with secrets |
| `cattery.services.acme` | Let's Encrypt SSL certificates | `enable`, `useRoot`, `email`, `group`, `dnsProvider`, `postRun`, `reloadServices`, `certs`, `extraOptions` |
| `cattery.services.acme.secrets` | Encrypted ACME DNS provider credentials | Auto-enabled with secrets |

### Git Forges

| Module | Description | Options |
|---|---|---|
| `cattery.services.forgejo` | Forgejo (Gitea fork) | `enable`, `dbBackend` (sqlite/mysql/postgresql), `useWizard`, `configFile.settingsPath`, `settings`, `extraOptions` |
| `cattery.services.forgejo.secrets` | Encrypted forgejo app.ini | Auto-enabled with secrets |
| `cattery.services.gitea` | Gitea | `enable`, `dbBackend`, `useWizard`, `configFile.settingsPath`, `settings`, `extraOptions` |
| `cattery.services.gitea.secrets` | Encrypted gitea app.ini | Auto-enabled with secrets |
| `cattery.services.gitea-actions-runner` | Gitea Actions CI runner | `enable`, `package`, `url`, `instances` (sub-modules with enable, name, url, tokenFile, labels, settings, extraOptions) |
| `cattery.services.gitea-actions-runner.secrets` | Encrypted runner token files | Auto-enabled with secrets |

### Databases

| Module | Description | Options |
|---|---|---|
| `cattery.services.postgresql` | PostgreSQL with external config files | `enable`, `package`, `openFirewall`, `configFile.settingsPath`, `configFile.identMapPath`, `configFile.authenticationPath`, `settings`, `extraOptions` |
| `cattery.services.postgresql.secrets` | Encrypted postgresql/pg\_hba/pg\_ident configs | Auto-enabled with secrets |

### Password Manager

| Module | Description | Options |
|---|---|---|
| `cattery.services.vaultwarden` | Vaultwarden (Bitwarden-compatible) | `enable`, `dbBackend`, `configFile.settingsPath`, `extraOptions` |
| `cattery.services.vaultwarden.secrets` | Encrypted vaultwarden env | Auto-enabled with secrets |

### VPN & Networking

| Module | Description | Options |
|---|---|---|
| `cattery.services.tailscale` | Tailscale mesh VPN | `enable`, `extraOptions` |
| `cattery.services.cloudflared` | Cloudflare Tunnel | `enable`, `tunnels`, `extraOptions` |
| `cattery.services.cloudflared.secrets` | Encrypted tunnel credentials | Auto-enabled with secrets |
| `cattery.services.wg-quick` | WireGuard wg-quick (cross-platform) | `enable`, `configPrefix`, `configNames` |
| `cattery.services.wg-quick.secrets` | Encrypted WireGuard configs | Auto-enabled with secrets |
| `cattery.services.sing-box` | Sing-box universal proxy | `enable`, `settings` (freeform JSON) |
| `cattery.services.sing-box.secrets` | Encrypted sing-box config.json | Auto-enabled with secrets |
| `cattery.services.smartdns` | SmartDNS with DNS/TLS/HTTPS | `enable`, `openFirewall`, `extraOptions` |

### Container & VM

| Module | Description | Options |
|---|---|---|
| `cattery.services.docker` | Docker with BTRFS storage | `enable`, `extraOptions` |
| `cattery.containers` | Declarative NixOS containers with auto IP | `enable`, per-container `services`, `sharedServices`, `extraOptions` |
| `cattery.services.qemu-guest` | QEMU guest agent | `enable` |
| `cattery.services.cloud-init` | cloud-init for cloud VMs | `enable`, `network.enable`, `extraOptions` |

### Dev Tools

| Module | Description | Options |
|---|---|---|
| `cattery.services.vscode-server` | VS Code remote server | `enable`, `extraOptions`, `persistence` |
| `cattery.services.openssh` | OpenSSH server | `enable`, `settings`, `extraOptions` |

### System Services

| Module | Description | Options |
|---|---|---|
| `cattery.services.cron` | Cron daemon | `enable`, `extraOptions` |
| `cattery.services.getty` | TTY autologin | `enable`, `autologinUser`, `extraOptions` |
| `cattery.cli-apps.cloudflared` | cloudflared CLI | `enable`, `persistence` |
| `cattery.services.awww` | Awww wallpaper rotation | `enable`, `mode`, `wallpaperDir`, `interval`, `resizeType`, `filter`, `transition`, `monitors` |
| `cattery.services.gpg-agent` | GPG agent with SSH support | `enable`, `enableSshSupport`, `enableExtraSocket`, `verbose`, `sshKeys`, `extraConfig`, `pinentry.package` |

## CLI Apps

### Development Kits

| Module | Description | Options |
|---|---|---|
| `cattery.cli-apps.dev-kit.git` | Git with GPG signing (openpgp/ssh/x509), delta, LFS, multi-credential | `enable`, `signing.format`, `signing.key`, `extraOptions`, `persistence` |
| `cattery.cli-apps.dev-kit.git.secrets` | Encrypted git include configs | Auto-enabled with secrets |
| `cattery.cli-apps.dev-kit.nix` | alejandra, nixfmt, nil, nix-tree | `enable` |
| `cattery.cli-apps.dev-kit.rust` | rustup, sccache | `enable`, `persistence` |
| `cattery.cli-apps.dev-kit.go` | Go toolchain | `enable` |
| `cattery.cli-apps.dev-kit.java` | JDK (GraalVM), Maven, Gradle | `enable` |
| `cattery.cli-apps.dev-kit.javascript` | Node.js, corepack, bun, pnpm, yarn | `enable`, `needs`, `persistence` |
| `cattery.cli-apps.dev-kit.cpp` | GCC, CMake, autoconf, automake | `enable` |
| `cattery.cli-apps.dev-kit.lua` | LuaJIT | `enable` |
| `cattery.cli-apps.dev-kit.wasm` | Binaryen, Emscripten | `enable` |
| `cattery.cli-apps.dev-kit.dive` | Docker image analyzer | `enable` |
| `cattery.cli-apps.dev-kit.jujutsu` | Jujutsu VCS with GPG signing | `enable` |

### Shells

| Module | Description | Options |
|---|---|---|
| `cattery.cli-apps.shell.fish` | Fish shell (auto-enables if defaultUserShell) | `enable`, `persistence` |
| `cattery.cli-apps.shell.zsh` | Zsh with autosuggestion + syntax highlighting | `enable` |
| `cattery.cli-apps.shell.nushell` | Nushell | `enable`, `settings`, `extraConfig`, `persistence` |
| `cattery.cli-apps.shell.atuin` | Shell history sync | `enable`, `persistence` |
| `cattery.cli-apps.shell.direnv` | direnv + nix-direnv | `enable`, `persistence` |
| `cattery.cli-apps.shell.starship` | Starship prompt | `enable`, `settings` |
| `cattery.cli-apps.shell.powershell` | PowerShell (Darwin-only) | `enable` |

### Editors

| Module | Description | Options |
|---|---|---|
| `cattery.cli-apps.editor.vim` | Vim | `enable`, `extraOptions` |
| `cattery.cli-apps.editor.neovim` | Neovim | `enable`, `extraOptions` |
| `cattery.cli-apps.editor.helix` | Helix | `enable`, `extraOptions` |

### File Management

| Module | Description | Options |
|---|---|---|
| `cattery.cli-apps.file-manager.yazi` | Yazi terminal file manager | `enable` |
| `cattery.cli-apps.disk` | ifuse, mtools, nfs-utils | `enable` |

### Security CLI

| Module | Description | Options |
|---|---|---|
| `cattery.cli-apps.security.gnupg` | GNUPG agent | `enable`, `agent.enable`, `agent.enableSSHSupport`, `agent.extraOptions` |
| `cattery.cli-apps.security.gnupg.secrets` | Encrypted gnupg files | Auto-enabled with secrets |
| `cattery.cli-apps.security.yubihsm` | YubiHSM tools (shell, connector) | `enable` |
| `cattery.cli-apps.security.fido2` | libfido2 for FIDO2 keys | `enable` |
| `cattery.cli-apps.openssh` | OpenSSH client | `enable` |

### SSH

| Module | Description | Options |
|---|---|---|
| `cattery.cli-apps.ssh` | SSH known\_hosts management | `knownHostsFileNames`, `knownHostsFiles` |
| `cattery.cli-apps.ssh.secrets` | Encrypted SSH known\_hosts | Auto-enabled with secrets |
| `cattery.cli-apps.mtr` | MTR network diagnostic | `enable` |

### Nix Tools

| Module | Description | Options |
|---|---|---|
| `cattery.cli-apps.nix.home-manager` | home-manager self-management | `enable`, `persistence` |
| `cattery.cli-apps.nix.nix-index` | nix-index + comma | `enable` |
| `cattery.cli-apps.nix.nix-ld` | nix-ld for non-NixOS binary compatibility | `enable` |

### Operations

| Module | Description |
|---|---|
| `cattery.cli-apps.operations.cloud` | turso-cli, awscli2 |
| `cattery.cli-apps.operations.kubernetes` | kubectl, helm, argocd |

### Tools

| Module | Description | Options |
|---|---|---|
| `cattery.cli-apps.tool.useful` | Shell aliases (git, convenience), optional nix aliases | `enable` |
| `cattery.cli-apps.tool.gh` | GitHub CLI | `enable`, `settings`, `persistence` |
| `cattery.cli-apps.tool.fastfetch` | System info fetcher | `enable`, `settings` |
| `cattery.cli-apps.tool.hyfetch` | Pride-themed fastfetch fork | `enable`, `settings` |
| `cattery.cli-apps.tool.http-utils` | wget, curl, aria2, wrk, oha | `enable` |
| `cattery.cli-apps.tool.compressor` | p7zip, gzip, zip, unzip, xz, zstd | `enable` |
| `cattery.cli-apps.tool.monitoring` | glances, inxi, iftop, btop, htop | `enable` |
| `cattery.cli-apps.tool.network` | inetutils (telnet, ping) | `enable` |
| `cattery.cli-apps.tool.installer` | disko, colmena, nixos-anywhere, deploy-rs | `enable` |
| `cattery.cli-apps.tool.tldr` | tlrc with periodic update service | `enable`, `persistence` |
| `cattery.cli-apps.tool.speedtest` | speedtest-cli, speedtest-go | `enable` |
| `cattery.cli-apps.tool.thefuck` | Auto-correct shell commands | `enable` |
| `cattery.cli-apps.tool.claude-code` | Claude Code with persistence | `enable`, `persistence` |
| `cattery.cli-apps.tool.opencode` | opencode with web UI | `enable`, `persistence` |
| `cattery.cli-apps.tool.ollama` | Ollama LLM runner | `enable` |
| `cattery.cli-apps.tool.misc` | Pre-commit cache persistence | `enable` |
| `cattery.cli-apps.tool.ventoy` | Ventoy bootable USB tool | `enable` |
| `cattery.cli-apps.tool.acme-sh` | acme.sh ACME client | `enable` |
| `cattery.cli-apps.misc` | psmisc (killall), usbutils (lsusb) | `enable` |
| `cattery.cli-apps.warp` | Cloudflare WARP | `enable` |

### Database CLI

| Module | Description |
|---|---|
| `cattery.cli-apps.database.sqlite` | SQLite |

### Video Tools

| Module | Description |
|---|---|
| `cattery.cli-apps.video.visual` | brotli, ffmpeg-full, imagemagick, flac, libheif, libwebp, optipng |
| `cattery.cli-apps.video.youtube` | yt-dlp |

## Apps (GUI)

### Development

| Module | Description | Options |
|---|---|---|
| `cattery.apps.vscode` | VS Code with wayland, profiles | `enable`, `profiles`, `commandLineArgs`, `defaultEditor`, `extraOptions`, `persistence` |
| `cattery.apps.code-cursor` | Cursor editor | `enable`, `defaultEditor`, `persistence` |
| `cattery.apps.jetbrains` (home) | All JetBrains IDEs | `enable`, `persistence` |
| `cattery.apps.jetbrains` (NixOS) | jetbrains-toolbox, Android Studio | `enable`, `persistence` |
| `cattery.apps.zed-editor` | Zed editor | `enable`, `package`, `extraPackages`, `userSettings`, `userKeymaps`, `userTasks`, `extensions`, `persistence` |

### Terminals

| Module | Description | Options |
|---|---|---|
| `cattery.apps.ghostty` | Ghostty terminal | `enable`, `settings` |
| `cattery.apps.wezterm` | WezTerm | `enable`, `extraConfig` |
| `cattery.apps.foot` | Foot terminal | `enable`, `settings` |

### Communication

| Module | Description | Options |
|---|---|---|
| `cattery.apps.instant-messengers` | Telegram, Vesktop (Discord), Signal, Element, Feishu | `enable`, `persistence` |
| `cattery.apps.slack` | Slack | `enable`, `persistence` |
| `cattery.apps.zoom-us` | Zoom | `enable` |

### Browser

| Module | Description | Options |
|---|---|---|
| `cattery.apps.browser` | Firefox/Chromium/Chrome with Wayland flags | `enable`, `needs`, `persistence` |
| `cattery.apps.thunderbird` | Thunderbird mail with GPG | `enable`, `persistence` |

### Productivity

| Module | Description | Options |
|---|---|---|
| `cattery.apps.useful` | FileZilla, GParted, Obsidian, Kleopatra, LibreOffice | `enable`, `persistence` |
| `cattery.apps.science` | GeoGebra | `enable`, `persistence` |
| `cattery.apps.safety` | Bitwarden desktop | `enable` |

### Graphics

| Module | Description | Options |
|---|---|---|
| `cattery.apps.graphics` | GIMP, Inkscape, nomacs, imv, Krita | `enable`, `persistence` |

### Remote Access

| Module | Description | Options |
|---|---|---|
| `cattery.apps.remote` | RustDesk, KRDC, Remmina | `enable`, `needs` |

### Video & Media

| Module | Description | Options |
|---|---|---|
| `cattery.apps.video` | Syncplay, VLC, mpv, OBS Studio | `enable`, `persistence` |
| `cattery.apps.iina` | IINA player (Darwin-only) | `enable` |

### Gaming Launchers

| Module | Description |
|---|---|
| `cattery.apps.game` | Heroic Games Launcher, r2modman |
| `cattery.apps.hmcl` | HMCL Minecraft launcher |

### Virtualization

| Module | Description | Options |
|---|---|---|
| `cattery.apps.vmware` | VMware guest + host | `enable`, `persistence` |
| `cattery.apps.winbox` | MikroTik Winbox (Linux) | `enable`, `package`, `openFirewall`, `persistence` |

### Darwin-specific Apps

| Module | Description |
|---|---|
| `cattery.cli-apps.android` | android-tools (Darwin-only) |

## System

### Core System

| Module | Description | Options |
|---|---|---|
| `cattery.nix` | Nix config (flakes, auto-optimise, GC, registry) | `enable` |
| `cattery.system.locale` | System locale | `enable`, `defaultLocale` |
| `cattery.system.time` | Timezone | `enable`, `timeZone` |
| `cattery.system.network` | NetworkManager | `enable` |
| `cattery.system.network.wireless` | iwd + NetworkManager WiFi | `enable` |
| `cattery.system.network.bridges` | Network bridges | Per-bridge: `interfaces`, `rstp`, `ipv4`, `ipv6`, `useDHCP` |
| `cattery.system.network.nat` | NAT with IPv6 | `enable`, `enableIPv6`, `internalInterfaces`, `externalInterface` |
| `cattery.system.peripherals` | CUPS, PipeWire, bluetooth, GPU 32-bit, geoclue | `enable` |
| `cattery.system.automount` | devmon, gvfs, udisks2 | `enable` |
| `cattery.system.fcitx5` | Fcitx5 with rime, GTK, Chinese addons | `enable`, `persistence` |
| `cattery.system.fonts` | Open Sans, Noto, Source Han, DejaVu, Fira Code, Monaspace, Nerd Fonts | `enable`, `persistence` |
| `cattery.system.ulimit` | Open files limit | `enable`, `openFilesLimit` |

### Boot

| Module | Description | Options |
|---|---|---|
| `cattery.system.boot.efi` | systemd-boot UEFI | `enable`, `configurationLimit` |
| `cattery.system.boot.grub` | GRUB with nixos-grub2-theme | `enable`, `device`, `configurationLimit` |
| `cattery.system.boot.kernel` | Kernel selection (latest/LTS/ZFS) | `enable`, `version`, `sysctl`, `useIpForward` |
| `cattery.system.boot.binfmt` | QEMU binfmt (aarch64 emulation) | `enable` |
| `cattery.system.boot.lanzaboote` | Secure Boot | `enable`, `pkiBundle`, `extraOptions` |

### File Systems

| Module | Description | Options |
|---|---|---|
| `cattery.system.fileSystems.samba` | CIFS/Samba auto-mounts with credentials | `hostUrl`, `binds` (uid, gid, autoMountOpts, secretsPath) |
| `cattery.system.fileSystems.samba.secrets` | Encrypted samba credential files | Auto-enabled with secrets |
| `cattery.system.fileSystems.btrfs.impermanence` | BTRFS subvolume rolling initrd service | Per-fs: `device`, `tempDir`, `oldSubvolDir`, `subvol` |

### Platform

| Module | Description | Options |
|---|---|---|
| `cattery.system.wsl` | NixOS-WSL with interop | `enable` |
| `cattery.system.proxmox.lxc` | Proxmox LXC container | `enable`, `manageNetwork`, `manageHostName` |
| `cattery.system.sudoTouch` | macOS Touch ID for sudo | `enable` |
| `cattery.system.useful` | macOS defaults (no quarantine, show extensions, hide desktop drives) | `enable` |
| `cattery.brew` | Homebrew with casks/brews (Darwin) | `enable`, `brews`, `casks` |

## User

### `cattery.user`

Core user configuration. Used as defaults by many modules.

| Option | Type | Description |
|---|---|---|
| `name` | str | Username |
| `realName` | str | Full name |
| `email.address` | str | Email address |
| `email.userName` | str | Git user name (defaults to realName) |
| `email.imap.host` | str | IMAP server host |
| `email.imap.port` | int | IMAP port |
| `email.smtp.host` | str | SMTP server host |
| `email.smtp.port` | int | SMTP port |
| `defaultUserShell` | str | Default shell (auto-enables fish/zsh based on value) |
| `gpg.signKey` | str | GPG signing key |
| `gpg.encryptKey` | str | GPG encryption key |
| `initialHashedPassword` | str | Initial user password hash |
| `useSecretPasswordFile` | bool | Use agenix for password |
| `authorizedKeys.keys` | list of str | SSH authorized keys |
| `authorizedKeys.keyFiles` | list of path | SSH authorized key files |
| `settings` | attrs | User settings dict (consumed by theme/desktop modules) |
| `home` | path | Read-only home directory |
| `uid` | int | Read-only UID |
| `gid` | int | Read-only GID |

### `cattery.home`

home-manager bridge for NixOS. Passes `extraOptions` to `home-manager.users.<name>`.

| Option | Type | Description |
|---|---|---|
| `extraOptions` | attrs | Extra home-manager options |

## Darwin-specific

| Module | Description | Options |
|---|---|---|
| `cattery.services.openssh` | OpenSSH on macOS | `enable`, `extraConfig`, `extraOptions` |
| `cattery.home` | Home-manager bridge on darwin | `extraOptions` |

***

> Every module accepts an `extraOptions` attrs merged via `//` for extensibility without patching.
> Home-manager modules with state use a `persistence` option (default `true`) to register with `cattery.system.impermanence`.
