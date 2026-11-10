# Impermanence

cattery has two impermanence modules. The NixOS module persists system paths; the home-manager module persists user state. Both wrap [nix-community/impermanence](https://github.com/nix-community/impermanence) and default to `/persistent`.

## NixOS

```nix
{
  cattery.system.impermanence = {
    enable = true;
    directories = [
      "/var/lib/my-service"
    ];
    files = [
      "/etc/my-service.conf"
    ];
  };
}
```

`environment.persistence."/persistent"` gets these entries by default:

| Path | Type |
|---|---|
| `/var/log` | directory |
| `/var/lib` | directory |
| `/etc/NetworkManager/system-connections` | directory |
| `/etc/ssh` | directory |
| `/etc/machine-id` | file |

`directories` and `files` append to that list. `extraOptions` is merged into the same attribute set.

The module also points `age.identityPaths` at the SSH host keys under `/persistent`, so agenix can decrypt host secrets after a reboot.

## home-manager

```nix
{
  cattery.system.impermanence = {
    enable = true;
    xdg.userDirs.projects = null;
  };
}
```

The module only writes persistence entries when `home.persistence` exists. In a NixOS + home-manager setup, that happens when `impermanence.nixosModules.impermanence` and `home-manager.nixosModules.home-manager` are imported; `cattery.nixosModules.default` includes both. Don't import `impermanence.homeManagerModules.*` yourself. Standalone home-manager has no `home.persistence`, so the module does nothing.

`directories` and `files` add paths on top of the defaults. `extraOptions` is merged into `home.persistence."/persistent"`.

Default entries:

| Path | Notes |
|---|---|
| `.ssh` | directory, mode `0700` |
| `.pki` | directory, mode `0700` |
| XDG user directories | Desktop, Documents, Downloads, Music, Pictures, Projects, Public, Templates, Videos |
| `~/.cache` | only the listed entries unless `xdg.cache.full` is true |
| `~/.config` | only the listed entries unless `xdg.config.full` is true |
| `~/.local/share` | only the listed entries unless `xdg.data.full` is true |
| `~/.local/state` | only the listed entries unless `xdg.state.full` is true |

The module also points `age.identityPaths` at `.ssh/id_ed25519` and `.ssh/id_rsa` under `/persistent`.

### XDG user directories

`xdg.userDirs.enable` is `true` by default, and `xdg.userDirs.full` cannot be turned off. Every non-null XDG directory is persisted:

```text
Desktop
Documents
Downloads
Music
Pictures
Projects
Public
Templates
Videos
```

`Projects` comes from `xdg-user-dirs` 0.20 and Home Manager's `xdg.userDirs.projects`. To skip it:

```nix
{
  cattery.system.impermanence.xdg.userDirs.projects = null;
}
```

Null entries are filtered out before they reach impermanence. Setting the option to `null` also clears `XDG_PROJECTS_DIR`, so Home Manager stops creating `~/Projects`.

### XDG cache, config, data, and state

Each of `xdg.cache`, `xdg.config`, `xdg.data`, and `xdg.state` has:

| Option | Default | Description |
|---|---|---|
| `enable` | `true` | Include this XDG base directory |
| `full` | `false` | Persist the whole base directory |
| `directories` | `[ ]` | Subdirectories to persist |
| `files` | `[ ]` | Files to persist |

Without `full`, only the entries in `directories` and `files` are persisted.

```nix
{
  cattery.system.impermanence = {
    xdg = {
      config.directories = [ "my-app" ];
      data.files = [ "my-app/state.db" ];
      cache.directories = [ "my-app/cache" ];
    };
  };
}
```

## BTRFS rollback

`cattery.system.fileSystems.btrfs.impermanence` runs in initrd. It snapshots the current subvolume, deletes it, creates a fresh one, then mounts root. Configure one entry per subvolume:

```nix
{
  cattery.system.fileSystems.btrfs.impermanence."@home".device =
    "/dev/disk/by-uuid/2f1dc58e-6d8a-4cb4-8247-b4e9acf39681";
}
```

| Option | Default | Description |
|---|---|---|
| `device` | required | Block device containing the subvolume |
| `subvol` | entry name | Subvolume to roll back |
| `tempDir` | `/btrfs_<subvol>_tmp` | Temporary mount point |
| `oldSubvolDir` | `old_<subvol>` | Where old snapshots are kept |

Archives older than 30 days are deleted.

## Secrets

The NixOS module persists `/etc/ssh`; the home-manager module persists `.ssh`. Decrypted secrets stay in `/run/agenix` and are not copied to `/persistent`.
