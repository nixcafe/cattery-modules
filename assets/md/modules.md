# Modules

cattery defines 262 module files under the `cattery` namespace. The count includes room profiles and `secrets` companion modules. Enable modules individually or use a room. The tables below list the modules and their main options. See the module source for the full option set.

## Theming

### cattery.desktop.addons.catppuccin

Catppuccin theming for the desktop environment. The module exists in the NixOS and home-manager sets.

```nix
cattery.desktop.addons.catppuccin.enable = true;
```

| Option | Description |
|---|---|
| `enable` | Enable Catppuccin |
| `autoEnable` | Enable all Catppuccin integrations by default. Defaults to the value of `enable` |
| `extraOptions` | Extra options merged into the Catppuccin configuration |

## Desktop

### Compositors and display managers

| Module | Description | Options |
|---|---|---|
| `cattery.desktop.hyprland` | Hyprland with XWayland (NixOS). The home-manager module adds `require` and `on` event callbacks | `enable`, `require`, `on` |
| `cattery.desktop.niri` | Niri configuration (home-manager) | `enable`, `configText`, `include`, `spawnAtStartup`, `binds` |
| `cattery.desktop.plasma` | KDE Plasma configuration through plasma-manager (home-manager) | `enable`, `settings` |
| `cattery.desktop.gnome` | GNOME with GDM (NixOS) | `enable` |
| `cattery.desktop.lightdm` | LightDM (NixOS) | `enable` |

### Hyprland themes

| Module | Description | Options |
|---|---|---|
| `cattery.desktop.hyprland.theme.charm-cat` | Hyprland theme with waybar, kitty, anyrun, hyprlock, mako, wlogout, and awww wallpaper | `enable`, `greetd.enable` (NixOS) |
| `cattery.desktop.hyprland.theme.caelestia` | Caelestia theme with SDDM on NixOS. The home-manager module provides settings and persistence | `enable`, `settings`, `persistence` |

### Charm-cat sub-modules

| Module | Description |
|---|---|
| `cattery.desktop.hyprland.theme.charm-cat.audio` | pipewire, wireplumber, pavucontrol, brightnessctl |
| `cattery.desktop.hyprland.theme.charm-cat.convention` | Workspace conventions, keybinds, monitor rules |
| `cattery.desktop.hyprland.theme.charm-cat.fcitx` | Fcitx5 input method integration |
| `cattery.desktop.hyprland.theme.charm-cat.file-manager` | Dolphin file manager |
| `cattery.desktop.hyprland.theme.charm-cat.launcher` | Anyrun with plugins |
| `cattery.desktop.hyprland.theme.charm-cat.lock-screen` | Hyprlock and hypridle screen lock |
| `cattery.desktop.hyprland.theme.charm-cat.notification` | Mako notification daemon |
| `cattery.desktop.hyprland.theme.charm-cat.screenshots` | Hyprshot, grim, slurp, and wl-clipboard |
| `cattery.desktop.hyprland.theme.charm-cat.terminal` | Kitty with JetBrains Mono Nerd Font |
| `cattery.desktop.hyprland.theme.charm-cat.vscode` | VS Code workspace integration |
| `cattery.desktop.hyprland.theme.charm-cat.wallpaper` | Awww wallpaper rotation |
| `cattery.desktop.hyprland.theme.charm-cat.waybar` | Waybar configuration |
| `cattery.desktop.hyprland.theme.charm-cat.wlogout` | Wlogout power menu |

### Caelestia sub-modules

| Module | Description |
|---|---|
| `cattery.desktop.hyprland.theme.caelestia.convention` | Settings, workspace action script, workspace switching |
| `cattery.desktop.hyprland.theme.caelestia.audio` | pipewire, wireplumber, pavucontrol, brightnessctl |
| `cattery.desktop.hyprland.theme.caelestia.fcitx` | Fcitx5 integration |
| `cattery.desktop.hyprland.theme.caelestia.file-manager` | Thunar with archive and volume plugins |
| `cattery.desktop.hyprland.theme.caelestia.idle` | Hypridle and the caelestia shell lock |
| `cattery.desktop.hyprland.theme.caelestia.screenshots` | Hyprshot screenshot tool |
| `cattery.desktop.hyprland.theme.caelestia.terminal` | Kitty with JetBrains Mono Nerd Font |

### Desktop addons

| Module | Description | Options |
|---|---|---|
| `cattery.desktop.addons.xdg-portal` | XDG Desktop Portal with wlr | `enable` |
| `cattery.desktop.addons.chromium-support` | Wayland Chromium and Electron (`NIXOS_OZONE_WL=1`) | `enable` |
| `cattery.desktop.xdg` | MIME default applications (home-manager) | `app.browser`, `app.editor`, `app.audio`, `app.image`, `app.video`, `app.mailto`, `app.calendar` |

### Hyprland addons

| Module | Description |
|---|---|
| `cattery.desktop.hyprland.addons.hyprshot` | Screenshot tool (hyprshot, grim, slurp) |
| `cattery.desktop.hyprland.addons.hyprlock` | Screen locker |
| `cattery.desktop.hyprland.addons.hypridle` | Idle management daemon |

## Gaming

| Module | Description | Options |
|---|---|---|
| `cattery.apps.game.steam` | Steam with protonup-qt, remote play, and hardware support | `enable`, `persistence` |
| `cattery.apps.game.gale` | Gale game launcher | `enable`, `persistence` |
| `cattery.apps.game` | Heroic Games Launcher and r2modman (home-manager) | `enable` |
| `cattery.apps.hmcl` | HMCL Minecraft launcher | `enable`, `persistence` |
| `cattery.system.gpu.amd` | AMD GPU driver (`amdgpu` kernel module) | `enable` |

## Security

### Secrets (agenix)

See the [Secrets and agenix](/secrets) page for setup details.

| Module | Description | Options |
|---|---|---|
| `cattery.secrets` | agenix secrets with host, shared, and user scopes | `enable`, `yubikey.enable`, `secretsDir`, `secretsMountPoint`, `secretsPath`, `hosts`, `shared`, `files` |
| `cattery.nix.secrets` | Encrypted Nix configuration included through `nix.extraOptions` | `enable`, `scope`, `etc.enable`, `etc.useSymlink`, `etc.dirPath`, `files` |

### Impermanence

See [Impermanence](/impermanence) for setup examples and the full list of persisted paths.

| Module | Description | Options |
|---|---|---|
| `cattery.system.impermanence` | Ephemeral root with persistent state (NixOS) | `enable`, `directories`, `files`, `persistencePath`, `extraOptions` |
| `cattery.system.impermanence` | Ephemeral home with persistent state (home-manager) | `enable`, `directories`, `files`, `persistencePath`, `xdg.userDirs`, `xdg.cache`, `xdg.config`, `xdg.data`, `xdg.state`, `extraOptions` |
| `cattery.system.fileSystems.btrfs.impermanence` | BTRFS subvolume rolling for impermanence | Per subvolume: `device`, `tempDir`, `oldSubvolDir`, `subvol` |

The home-manager module persists `.ssh`, `.pki`, and the XDG user directories by default.

`xdg.userDirs` has `enable` and a read-only `full`. `xdg.cache`, `xdg.config`, `xdg.data`, and `xdg.state` add `directories` and `files`. Set `xdg.userDirs.projects = null` to skip the `Projects` directory introduced by `xdg-user-dirs` 0.20.

### Secure Boot

| Module | Description | Options |
|---|---|---|
| `cattery.system.boot.lanzaboote` | Secure Boot with lanzaboote | `enable`, `pkiBundle`, `extraOptions` |

### Other security

| Module | Description | Options |
|---|---|---|
| `cattery.security.pam` | PAM configuration passthrough | Attribute set merged into `security.pam` |
| `cattery.apps.yubikey` | YubiKey packages, pcscd, and optional agent | `enable`, `agent.enable`, `touch-detector.enable` |
| `cattery.apps.safety` | Bitwarden desktop (home-manager) | `enable` |

## Services

### Web and reverse proxy

| Module | Description | Options |
|---|---|---|
| `cattery.services.nginx` | Nginx with `conf.d` includes | `enable`, `httpSubConfigPath`, `commonHttpConfig`, `httpConfig`, `appendHttpConfig`, `virtualHosts`, `preStart`, `extraOptions` |
| `cattery.services.nginx.secrets` | Encrypted nginx `conf.d` files | Auto-enabled with secrets |
| `cattery.services.acme` | Let's Encrypt certificates | `enable`, `useRoot`, `email`, `group`, `dnsProvider`, `postRun`, `reloadServices`, `certs`, `extraOptions` |
| `cattery.services.acme.secrets` | Encrypted ACME DNS provider credentials | Auto-enabled with secrets |
| `cattery.services.adguardhome` | AdGuard Home DNS server and web interface | `enable`, `package`, `openFirewall`, `allowDHCP`, `mutableSettings`, `host`, `port`, `settings`, `useWizard`, `extraArgs`, `extraOptions` |
| `cattery.services.adguardhome.secrets` | Encrypted `AdGuardHome.yaml` | Auto-enabled with secrets. Uses the file when `useWizard` is set |
| `cattery.services.avahi` | Avahi mDNS | `enable`, `openFirewall`, `publish.enable`, `extraOptions` |

### Git forges

| Module | Description | Options |
|---|---|---|
| `cattery.services.forgejo` | Forgejo | `enable`, `dbBackend`, `useWizard`, `configFile.settingsPath`, `settings`, `extraOptions` |
| `cattery.services.forgejo.secrets` | Encrypted Forgejo `app.ini` | Auto-enabled with secrets. Uses the file when `useWizard` is set |
| `cattery.services.gitea` | Gitea | `enable`, `dbBackend`, `useWizard`, `configFile.settingsPath`, `settings`, `extraOptions` |
| `cattery.services.gitea.secrets` | Encrypted Gitea `app.ini` | Auto-enabled with secrets. Uses the file when `useWizard` is set |
| `cattery.services.gitea-actions-runner` | Gitea Actions CI runner | `enable`, `package`, `url`, `instances.<name>.enable`, `instances.<name>.name`, `instances.<name>.url`, `instances.<name>.tokenFile`, `instances.<name>.labels`, `instances.<name>.settings`, `instances.<name>.extraOptions` |
| `cattery.services.gitea-actions-runner.secrets` | Encrypted runner token files | Auto-enabled with secrets |

### Databases

| Module | Description | Options |
|---|---|---|
| `cattery.services.postgresql` | PostgreSQL with optional external configuration | `enable`, `package`, `dataDir`, `openFirewall`, `enableTCPIP`, `useWizard`, `configFile.settingsPath`, `settings`, `enableJIT`, `extraOptions`, `ensureDatabases`, `ensureUsers` |
| `cattery.services.postgresql.secrets` | Encrypted PostgreSQL configuration | Auto-enabled with secrets. Uses the file when `useWizard` is set |

### Password manager

| Module | Description | Options |
|---|---|---|
| `cattery.services.vaultwarden` | Vaultwarden (Bitwarden-compatible) | `enable`, `dbBackend`, `configFile.settingsPath`, `extraOptions` |
| `cattery.services.vaultwarden.secrets` | Encrypted Vaultwarden environment file | Auto-enabled with secrets |

### VPN and networking

| Module | Description | Options |
|---|---|---|
| `cattery.services.tailscale` | Tailscale | `enable`, `extraOptions` |
| `cattery.services.cloudflared` | Cloudflare Tunnel | `enable`, `tunnels`, `extraOptions` |
| `cattery.services.cloudflared.secrets` | Encrypted tunnel credentials | Auto-enabled with secrets |
| `cattery.services.wg-quick` | WireGuard `wg-quick` | `enable`, `configPrefix`, `configNames` |
| `cattery.services.wg-quick.secrets` | Encrypted WireGuard configurations | Auto-enabled with secrets |
| `cattery.services.sing-box` | sing-box proxy | `enable`, `settings` |
| `cattery.services.sing-box.secrets` | Encrypted `config.json` | Auto-enabled with secrets |
| `cattery.services.smartdns` | SmartDNS | `enable`, `openFirewall`, `extraOptions` |

### Containers and virtual machines

| Module | Description | Options |
|---|---|---|
| `cattery.services.docker` | Docker with BTRFS storage on non-container systems | `enable`, `extraOptions` |
| `cattery.services.containerd` | containerd runtime | `enable`, `settings`, `extraPackages`, `extraOptions` |
| `cattery.containers` | Declarative NixOS containers with automatic IP addresses | Per container: `autoStart`, `modules`, `userName`, `networkMode`, `hostBridge`, `forwardPorts`, `autoGenerateStaticIp`, `bindMounts`, `hostModules`, `specialArgs`, `config`, `extraOptions` |
| `cattery.services.qemu-guest` | QEMU guest agent | `enable` |
| `cattery.services.cloud-init` | cloud-init for cloud VMs | `enable`, `network.enable`, `extraOptions` |
| `cattery.services.firecracker` | Firecracker microVM support | `enable`, `extraPackages`, `user`, `group`, `stateDir`, `enableKVM`, `kernelModules` |
| `cattery.services.flintlock` | Flintlock microVM lifecycle service | `enable`, `stateDir`, `socketDir`, `containerdSocket`, `containerdNamespace`, `grpcEndpoint`, `enableHttp`, `httpEndpoint`, `insecure`, `tlsCert`, `tlsKey`, `parentInterface`, `bridgeName`, `enableExecApi`, `enableSshProxyApi`, `verbosity`, `extraFlags` |

### Storage and file sharing

| Module | Description | Options |
|---|---|---|
| `cattery.services.samba` | Samba server | `enable`, `openFirewall`, `useWizard`, `configFile.settingsPath`, `settings`, `persistence`, `extraOptions` |
| `cattery.services.samba.secrets` | Encrypted `smb.conf` | Auto-enabled with secrets. Uses the file when `useWizard` is set |
| `cattery.services.samba-wsdd` | Samba Web Service Discovery | `enable`, `openFirewall`, `extraOptions` |
| `cattery.services.nfs` | NFS server | `enable`, `openFirewall`, `useWizard`, `configFile.settingsPath`, `exports`, `extraOptions` |
| `cattery.services.nfs.secrets` | Encrypted exports file | Auto-enabled with secrets. Uses the file when `useWizard` is set |
| `cattery.services.sanoid` | Sanoid ZFS snapshots | `enable`, `useWizard`, `configFile.settingsPath`, `templates`, `datasets`, `interval`, `extraArgs`, `persistence`, `extraOptions` |
| `cattery.services.sanoid.secrets` | Encrypted Sanoid configuration | Auto-enabled with secrets. Uses the file when `useWizard` is set |
| `cattery.services.syncoid` | Syncoid ZFS replication | `enable`, `interval`, `commands`, `commonArgs`, `sshKey`, `extraOptions` |
| `cattery.services.target` | LIO iSCSI target | `enable`, `openFirewall`, `useWizard`, `configFile.enable`, `configFile.settingsPath`, `persistence`, `extraOptions` |
| `cattery.services.target.secrets` | Encrypted target configuration | Auto-enabled with secrets. Uses the file when `useWizard` is set |

### Orchestration and monitoring

| Module | Description | Options |
|---|---|---|
| `cattery.services.k3s` | K3s Kubernetes | `enable`, `role`, `serverAddr`, `tokenFile`, `agentTokenFile`, `clusterInit`, `disableAgent`, `disable`, `extraFlags`, `configPath`, `nodeName`, `nodeIP`, `manifests`, `autoDeployCharts`, `charts`, `extraPackages`, `openFirewall`, `extraOptions` |
| `cattery.services.kubernetes` | Upstream Kubernetes | `enable`, `roles`, `masterAddress`, `apiserverAddress`, `clusterCidr`, `easyCerts`, `dataDir`, `featureGates`, `extraPackages`, `openFirewall`, `extraOptions` |
| `cattery.services.hydra` | Hydra continuous integration server | `enable`, `openFirewall`, `hydraURL`, `port`, `listenHost`, `notificationSender`, `smtpHost`, `useSubstitutes`, `minimumDiskFree`, `minimumDiskFreeEvaluator`, `extraConfig`, `extraOptions` |
| `cattery.services.netdata` | Netdata monitoring | `enable`, `config`, `extraOptions` |
| `cattery.services.beszel` | Beszel monitoring hub and agent | `enable`, `openFirewall`, `hub.enable`, `hub.host`, `hub.port`, `agent.enable`, `agent.environmentFile`, `agent.smartmon.enable`, `extraOptions` |
| `cattery.services.beszel.secrets` | Encrypted beszel agent environment file | Auto-enabled with secrets and the agent |

### Development and system services

| Module | Description | Options |
|---|---|---|
| `cattery.services.vscode-server` | VS Code remote server | `enable`, `extraOptions`, `persistence` |
| `cattery.services.openssh` | OpenSSH server | `enable`, `settings`, `extraOptions` |
| `cattery.services.cron` | Cron daemon | `enable`, `extraOptions` |
| `cattery.services.getty` | TTY autologin | `enable`, `autologinUser`, `extraOptions` |
| `cattery.services.gpg-agent` | GPG agent with SSH support (home-manager) | `enable`, `enableSshSupport`, `enableExtraSocket`, `verbose`, `sshKeys`, `extraConfig`, `pinentry.package`, `extraOptions` |
| `cattery.services.awww` | Awww wallpaper rotation (home-manager) | `enable`, `mode`, `wallpaperDir`, `interval`, `resizeType`, `transition`, `extraOptions` |

## CLI apps

### Development kits

| Module | Description | Options |
|---|---|---|
| `cattery.cli-apps.dev-kit.git` | Git with signing, LFS, and credential helpers | `enable`, `signing`, `sendEmail`, `includes`, `ignores`, `settings`, `extraOptions` |
| `cattery.cli-apps.dev-kit.git.secrets` | Encrypted Git include configuration | Auto-enabled with secrets |
| `cattery.cli-apps.dev-kit.nix` | alejandra, nixfmt, nil, nix-tree | `enable` |
| `cattery.cli-apps.dev-kit.rust` | rustup and sccache | `enable`, `persistence` |
| `cattery.cli-apps.dev-kit.go` | Go toolchain | `enable` |
| `cattery.cli-apps.dev-kit.java` | JDK (GraalVM by default), Maven, Gradle | `enable`, `jdk`, `maven.enable`, `gradle.enable`, `gradle.home`, `gradle.initScripts`, `gradle.settings`, `persistence` |
| `cattery.cli-apps.dev-kit.javascript` | Node.js, corepack, bun, pnpm, yarn | `enable`, `needs`, `persistence` |
| `cattery.cli-apps.dev-kit.cpp` | GCC, CMake, autoconf, automake | `enable` |
| `cattery.cli-apps.dev-kit.lua` | LuaJIT | `enable` |
| `cattery.cli-apps.dev-kit.wasm` | Binaryen, Emscripten | `enable` |
| `cattery.cli-apps.dev-kit.dive` | Docker image analyzer | `enable` |
| `cattery.cli-apps.dev-kit.jujutsu` | Jujutsu VCS with signing support | `enable`, `signing`, `ignores`, `settings`, `extraOptions`, `persistence` |

### Shells

| Module | Description | Options |
|---|---|---|
| `cattery.cli-apps.shell.fish` | Fish shell | `enable`, `persistence` |
| `cattery.cli-apps.shell.zsh` | Zsh with autosuggestion and syntax highlighting | `enable` |
| `cattery.cli-apps.shell.nushell` | Nushell | `enable`, `settings`, `extraConfig`, `persistence` |
| `cattery.cli-apps.shell.atuin` | Shell history sync | `enable`, `persistence` |
| `cattery.cli-apps.shell.direnv` | direnv and nix-direnv | `enable`, `persistence` |
| `cattery.cli-apps.shell.starship` | Starship prompt | `enable`, `settings` |
| `cattery.cli-apps.shell.powershell` | PowerShell (Darwin) | `enable` |

### Editors

| Module | Description | Options |
|---|---|---|
| `cattery.cli-apps.editor.vim` | Vim | `enable`, `extraOptions` |
| `cattery.cli-apps.editor.neovim` | Neovim | `enable`, `extraOptions` |
| `cattery.cli-apps.editor.helix` | Helix | `enable`, `extraOptions` |

### File management

| Module | Description | Options |
|---|---|---|
| `cattery.cli-apps.file-manager.yazi` | Yazi terminal file manager | `enable` |
| `cattery.cli-apps.disk` | ifuse, mtools, nfs-utils | `enable` |

### Security CLI

| Module | Description | Options |
|---|---|---|
| `cattery.cli-apps.security.gnupg` | GnuPG. The NixOS module adds agent options; the home-manager module adds persistence | `enable`, `agent.enable`, `agent.enableSSHSupport`, `agent.extraOptions`, `persistence` |
| `cattery.cli-apps.security.gnupg.secrets` | Encrypted GnuPG files | Auto-enabled with secrets |
| `cattery.cli-apps.security.yubihsm` | YubiHSM shell and connector | `enable` |
| `cattery.cli-apps.security.fido2` | libfido2 | `enable` |
| `cattery.cli-apps.openssh` | OpenSSH client | `enable` |

### SSH

| Module | Description | Options |
|---|---|---|
| `cattery.cli-apps.ssh` | SSH client configuration (home-manager) | `enable`, `includeNames`, `includes` |
| `cattery.cli-apps.ssh` | SSH known hosts management (NixOS) | `knownHostsFileNames`, `knownHostsFiles` |
| `cattery.cli-apps.ssh.secrets` | Encrypted SSH include files or known hosts files | Auto-enabled with secrets |
| `cattery.cli-apps.mtr` | MTR network diagnostic | `enable` |

### Nix tools

| Module | Description | Options |
|---|---|---|
| `cattery.cli-apps.nix.home-manager` | home-manager self-management | `enable`, `persistence` |
| `cattery.cli-apps.nix.nix-index` | nix-index and comma | `enable` |
| `cattery.cli-apps.nix.nix-ld` | nix-ld for non-NixOS binaries | `enable` |

### Operations

| Module | Description | Options |
|---|---|---|
| `cattery.cli-apps.operations.cloud` | turso-cli, awscli2 | `enable`, `persistence` |
| `cattery.cli-apps.operations.kubernetes` | kubectl, helm, argocd | `enable`, `persistence` |
| `cattery.cli-apps.operations.serverless` | faas-cli, kn, func, fission, nomad | `enable`, `persistence` |

### Tools

| Module | Description | Options |
|---|---|---|
| `cattery.cli-apps.tool.useful` | CLI packages and shell aliases | `enable`, `commonAliases`, `persistence` |
| `cattery.cli-apps.tool.gh` | GitHub CLI | `enable`, `settings`, `extraOptions`, `persistence` |
| `cattery.cli-apps.tool.fastfetch` | System information fetcher | `enable`, `settings` |
| `cattery.cli-apps.tool.hyfetch` | Pride-themed fastfetch fork | `enable`, `settings` |
| `cattery.cli-apps.tool.http-utils` | wget, curl, aria2, wrk, oha | `enable` |
| `cattery.cli-apps.tool.compressor` | p7zip, unar, gzip, bzip2, zip, unzip, xz, zstd | `enable` |
| `cattery.cli-apps.tool.monitoring` | glances, inxi, iftop, btop, htop | `enable` |
| `cattery.cli-apps.tool.network` | inetutils (telnet, ping) | `enable` |
| `cattery.cli-apps.tool.installer` | disko, colmena, nixos-anywhere, deploy-rs | `enable`, `persistence` |
| `cattery.cli-apps.tool.tldr` | tlrc with a periodic update service | `enable`, `period`, `persistence` |
| `cattery.cli-apps.tool.speedtest` | speedtest-cli and speedtest-go | `enable` |
| `cattery.cli-apps.tool.thefuck` | Command correction | `enable` |
| `cattery.cli-apps.tool.claude-code` | Claude Code | `enable`, `persistence` |
| `cattery.cli-apps.tool.opencode` | opencode | `enable`, `persistence` |
| `cattery.cli-apps.tool.pi` | pi coding agent | `enable`, `persistence`, `settings`, `models`, `context`, `extraPackages` |
| `cattery.cli-apps.tool.tea` | tea CLI with a Git credential helper | `enable`, `package`, `gitCredentialHelper.enable`, `gitCredentialHelper.hosts`, `persistence` |
| `cattery.cli-apps.tool.feishu-cli` | Feishu CLI | `enable`, `persistence` |
| `cattery.cli-apps.tool.lark-cli` | Lark CLI | `enable`, `persistence` |
| `cattery.cli-apps.tool.ollama` | Ollama | `enable` |
| `cattery.cli-apps.tool.codex` | OpenAI Codex CLI | `enable`, `persistence`, `settings`, `context` |
| `cattery.cli-apps.tool.misc` | Pre-commit cache persistence | `enable`, `persistence` |
| `cattery.cli-apps.tool.ventoy` | Ventoy bootable USB tool | `enable` |
| `cattery.cli-apps.tool.acme-sh` | acme.sh ACME client | `enable` |
| `cattery.cli-apps.misc` | psmisc (killall), usbutils (lsusb) | `enable` |
| `cattery.cli-apps.warp` | Cloudflare WARP | `enable` |
| `cattery.cli-apps.cloudflared` | cloudflared CLI | `enable`, `persistence` |

### Database CLI

| Module | Description | Options |
|---|---|---|
| `cattery.cli-apps.database.sqlite` | SQLite | `enable` |

### Video tools

| Module | Description | Options |
|---|---|---|
| `cattery.cli-apps.video.visual` | brotli, ffmpeg-full, imagemagick, flac, libheif, libwebp, optipng | `enable` |
| `cattery.cli-apps.video.youtube` | yt-dlp | `enable` |

## Apps (GUI)

### Development

| Module | Description | Options |
|---|---|---|
| `cattery.apps.vscode` | VS Code with Wayland support and profiles | `enable`, `profiles`, `commandLineArgs`, `defaultEditor`, `extraOptions`, `persistence` |
| `cattery.apps.code-cursor` | Cursor editor | `enable`, `defaultEditor`, `persistence` |
| `cattery.apps.jetbrains` | JetBrains IDEs (home-manager). On NixOS the module also installs Toolbox and Android Studio | `enable`, `persistence` |
| `cattery.apps.zed-editor` | Zed editor | `enable`, `extraPackages`, `userSettings`, `userKeymaps`, `userTasks`, `extensions`, `mutableUserTasks`, `installRemoteServer`, `defaultEditor`, `extraOptions`, `persistence` |

### Terminals

| Module | Description | Options |
|---|---|---|
| `cattery.apps.ghostty` | Ghostty terminal | `enable`, `settings` |
| `cattery.apps.wezterm` | WezTerm | `enable`, `extraConfig` |
| `cattery.apps.foot` | Foot terminal | `enable`, `settings` |

### Communication

| Module | Description | Options |
|---|---|---|
| `cattery.apps.instant-messengers` | Telegram and Vesktop (Discord), plus Signal, Element, and Feishu on Linux | `enable`, `persistence` |
| `cattery.apps.slack` | Slack | `enable`, `persistence` |
| `cattery.apps.zoom-us` | Zoom | `enable` |

### Browser and mail

| Module | Description | Options |
|---|---|---|
| `cattery.apps.browser` | Firefox, Chromium, or Chrome with Wayland flags | `enable`, `needs`, `persistence` |
| `cattery.apps.thunderbird` | Thunderbird with optional search settings | `enable`, `search`, `settings`, `persistence` |

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

### Remote access

| Module | Description | Options |
|---|---|---|
| `cattery.apps.remote` | RustDesk, KRDC, Remmina | `enable`, `needs`, `persistence` |

### Video and media

| Module | Description | Options |
|---|---|---|
| `cattery.apps.video` | Syncplay, VLC, mpv, OBS Studio | `enable`, `persistence` |
| `cattery.apps.iina` | IINA player (Darwin) | `enable` |

### Gaming launchers

| Module | Description | Options |
|---|---|---|
| `cattery.apps.game` | Heroic Games Launcher and r2modman | `enable` |
| `cattery.apps.hmcl` | HMCL Minecraft launcher | `enable`, `persistence` |

### Virtualization

| Module | Description | Options |
|---|---|---|
| `cattery.apps.vmware` | VMware guest and host | `enable`, `persistence` |
| `cattery.apps.winbox` | MikroTik Winbox (Linux) | `enable`, `package`, `openFirewall`, `persistence` |

## System

### Core system

| Module | Description | Options |
|---|---|---|
| `cattery.nix` | Nix settings: flakes, automatic optimisation, garbage collection, and a `beans` registry entry | `enable` |
| `cattery.system.locale` | System locale | `enable`, `defaultLocale` |
| `cattery.system.time` | Time zone | `enable`, `timeZone` |
| `cattery.system.network` | NetworkManager | `enable` |
| `cattery.system.network.wireless` | iwd and NetworkManager Wi-Fi | `enable` |
| `cattery.system.network.bridges` | Network bridges | Per bridge: `interfaces`, `rstp`, `ipv4`, `ipv6`, `useDHCP` |
| `cattery.system.network.nat` | NAT with IPv6 | `enable`, `enableIPv6`, `internalInterfaces`, `externalInterface` |
| `cattery.system.peripherals` | CUPS, PipeWire, Bluetooth, 32-bit graphics, geoclue | `enable` |
| `cattery.system.automount` | devmon, gvfs, udisks2 | `enable` |
| `cattery.system.fcitx5` | Fcitx5 with rime and GTK addons | `enable`, `persistence` |
| `cattery.system.fonts` | Open Sans, Noto, Source Han, DejaVu, Fira Code, Monaspace, Nerd Fonts | `enable`, `packages`, `extraPackages` |
| `cattery.system.ulimit` | Open files limit | `enable`, `openFilesLimit` |

### Boot

| Module | Description | Options |
|---|---|---|
| `cattery.system.boot.efi` | systemd-boot UEFI | `enable`, `configurationLimit` |
| `cattery.system.boot.grub` | GRUB with nixos-grub2-theme | `enable`, `device`, `configurationLimit` |
| `cattery.system.boot.kernel` | Kernel selection and sysctl settings | `useLatest`, `version`, `useLatestZfsCompatible`, `sysctl`, `useIpForward` |
| `cattery.system.boot.binfmt` | QEMU binfmt for aarch64 emulation | `enable` |
| `cattery.system.boot.lanzaboote` | Secure Boot with lanzaboote | `enable`, `pkiBundle`, `extraOptions` |

### File systems

| Module | Description | Options |
|---|---|---|
| `cattery.system.fileSystems.btrfs.impermanence` | BTRFS subvolume rolling initrd service | Per subvolume: `device`, `tempDir`, `oldSubvolDir`, `subvol` |
| `cattery.system.fileSystems.nfs` | NFS client mounts | `enable`, `client.<name>.server`, `client.<name>.mounts.<name>.export`, `client.<name>.mounts.<name>.mountPoint`, `client.<name>.mounts.<name>.autoMountOpts`, `client.<name>.mounts.<name>.extraOptions` |
| `cattery.system.fileSystems.samba` | CIFS and Samba client mounts | `enable`, `client.<name>.hostUrl`, `client.<name>.binds.<name>.uid`, `client.<name>.binds.<name>.gid`, `client.<name>.binds.<name>.autoMountOpts`, `client.<name>.binds.<name>.secretsPath`, `client.<name>.binds.<name>.extraOptions` |
| `cattery.system.fileSystems.samba.secrets` | Encrypted Samba client credential files | Auto-enabled with secrets |
| `cattery.system.fileSystems.webdav` | WebDAV client mounts | `enable`, `client.<name>.url`, `client.<name>.mounts.<name>.path`, `client.<name>.mounts.<name>.mountPoint`, `client.<name>.mounts.<name>.autoMountOpts`, `client.<name>.mounts.<name>.extraOptions` |
| `cattery.system.fileSystems.webdav.secrets` | Encrypted WebDAV credentials | Auto-enabled with secrets |
| `cattery.system.fileSystems.zfs` | ZFS support with scrub, trim, and snapshot services | `enable`, `autoScrub.enable`, `autoScrub.interval`, `autoSnapshot.enable`, `trim.enable`, `trim.interval`, `persistence`, `extraOptions` |

### Platform

| Module | Description | Options |
|---|---|---|
| `cattery.system.wsl` | NixOS-WSL integration | `enable` |
| `cattery.system.proxmox.lxc` | Proxmox LXC container | `enable`, `manageNetwork`, `manageHostName` |
| `cattery.system.sudoTouch` | macOS Touch ID for sudo | `enable` |
| `cattery.system.useful` | macOS defaults | `enable` |
| `cattery.brew` | Homebrew with brews and casks (Darwin) | `enable`, `brews`, `casks` |

## User

### cattery.user

Core user configuration. Many modules read these values for defaults.

| Option | Type | Description |
|---|---|---|
| `name` | str | User name |
| `realName` | null or str | Full name, used for the Git user name |
| `email.address` | null or str | Email address |
| `email.userName` | null or str | Mail account user name, defaults to `email.address` |
| `email.imap` | null or submodule | IMAP settings with `host` and `port` |
| `email.smtp` | null or submodule | SMTP settings with `host` and `port` |
| `defaultUserShell` | null or path or package | Login shell, for example `pkgs.fish`. The matching shell module enables by default |
| `gpg.signKey` | null or str | GPG signing key |
| `gpg.encryptKey` | null or str | GPG encryption key |
| `initialHashedPassword` | null or str | Initial user password hash |
| `useSecretPasswordFile` | bool | Read the password from an agenix secret |
| `authorizedKeys.keys` | list of str | SSH authorized keys |
| `authorizedKeys.keyFiles` | list of path | Files containing SSH authorized keys |
| `settings` | attrs | Extra values consumed by theme and desktop modules |
| `home` | null or str | Home directory (read-only) |
| `uid` | null or int | User ID (read-only) |
| `gid` | null or int | Group ID (read-only) |

### cattery.home

home-manager bridge. It forwards `extraOptions` to `home-manager.users.<name>`.

| Option | Type | Description |
|---|---|---|
| `extraOptions` | attrs | Extra home-manager options |

## Darwin-specific

| Module | Description | Options |
|---|---|---|
| `cattery.services.openssh` | OpenSSH on macOS | `enable`, `extraConfig`, `extraOptions` |
| `cattery.cli-apps.android` | android-tools (Darwin) | `enable` |
| `cattery.home` | home-manager bridge on Darwin | `extraOptions` |

***

Most modules accept an `extraOptions` attribute set that is merged into the underlying NixOS or home-manager options. Many home-manager modules that write state also expose a `persistence` option, default `true`, which registers paths with `cattery.system.impermanence`.
