# Secrets & agenix

cattery integrates [agenix](https://github.com/ryantm/agenix) for encrypted secrets. Service modules that need configuration files have a companion `secrets` module. The companion module adds the encrypted files to `age.secrets`. Many of these modules also link the decrypted file into `/etc`.

## File layout

`cattery.secrets.secretsPath` defaults to `<user.home>/agenix`. The files under that directory are grouped by scope:

```
<secretsPath>/
├── hosts/<host>/global/        # host-specific, root-owned
├── hosts/<host>/users/<user>/  # host-specific, user-owned
├── shared/global/              # shared across hosts, root-owned
└── shared/users/<user>/        # shared across hosts, user-owned
```

If you keep secrets in your flake, point the option at that directory:

```nix
cattery.secrets.secretsPath = ./secrets;
```

The keys in `secrets.nix` must match the file paths under `secretsPath`.

## Enabling secrets

```nix
{
  cattery.secrets.enable = true;
}
```

`enable` installs the agenix CLI and generates `age.secrets` from the configured files. `cattery.secrets.secretsDir` and `cattery.secrets.secretsMountPoint` are passed to agenix when set.

## Service secrets

Most companion modules enable themselves when both the parent service and `cattery.secrets` are enabled:

```nix
cattery = {
  secrets.enable = true;

  services.nginx.enable = true;      # encrypted nginx conf.d files
  services.forgejo.enable = true;    # encrypted Forgejo app.ini when useWizard is set
  services.postgresql.enable = true; # encrypted PostgreSQL config when useWizard is set
  services.wg-quick = {
    enable = true;
    configNames = [ "wg0" ];
  };
  services.cloudflared.enable = true; # encrypted tunnel credentials
};
```

For services with a host configuration file, set `useWizard = true` on the service to use the encrypted file instead of declarative settings.

`cattery.nix.secrets` is different: it is disabled by default. Set `cattery.nix.secrets.enable = true` to add the encrypted include to `nix.extraOptions`.

## Secret modules

| Module | Secret files |
|---|---|
| `cattery.secrets` | Main secrets configuration (hosts, shared, files) |
| `cattery.nix.secrets` | Encrypted Nix configuration included through `nix.extraOptions` |
| `cattery.services.nginx.secrets` | nginx `conf.d` files |
| `cattery.services.acme.secrets` | ACME DNS provider environment files |
| `cattery.services.adguardhome.secrets` | `AdGuardHome.yaml` when `useWizard` is set |
| `cattery.services.forgejo.secrets` | Forgejo `app.ini` when `useWizard` is set |
| `cattery.services.gitea.secrets` | Gitea `app.ini` when `useWizard` is set |
| `cattery.services.gitea-actions-runner.secrets` | Runner token environment files |
| `cattery.services.postgresql.secrets` | PostgreSQL configuration when `useWizard` is set |
| `cattery.services.vaultwarden.secrets` | Vaultwarden environment file |
| `cattery.services.cloudflared.secrets` | Tunnel credential files |
| `cattery.services.wg-quick.secrets` | WireGuard configuration files |
| `cattery.services.sing-box.secrets` | sing-box `config.json` |
| `cattery.services.samba.secrets` | Samba `smb.conf` when `useWizard` is set |
| `cattery.services.nfs.secrets` | NFS exports file when `useWizard` is set |
| `cattery.services.sanoid.secrets` | Sanoid configuration when `useWizard` is set |
| `cattery.services.target.secrets` | iSCSI target configuration when `useWizard` is set |
| `cattery.services.beszel.secrets` | Beszel agent environment file |
| `cattery.system.fileSystems.samba.secrets` | Samba client credential files |
| `cattery.system.fileSystems.webdav.secrets` | WebDAV credentials |
| `cattery.cli-apps.ssh.secrets` | SSH include files (home-manager) or known hosts files (NixOS) |
| `cattery.cli-apps.security.gnupg.secrets` | GnuPG files |
| `cattery.cli-apps.dev-kit.git.secrets` | Git include configuration |

## Secret scopes

| Scope | Path | Owner | Typical use |
|---|---|---|---|
| `hosts-global` | `hosts/<host>/global/` | root | System configuration for one host |
| `hosts-user` | `hosts/<host>/users/<user>/` | user | User configuration for one host |
| `shared-global` | `shared/global/` | root | System configuration shared by all hosts |
| `shared-user` | `shared/users/<user>/` | user | User configuration shared by all hosts |

Not every module uses the same default scope. For example, `cattery.services.acme.secrets`, `cattery.services.cloudflared.secrets`, and `cattery.system.fileSystems.samba.secrets` default to `shared-global`. The module source sets the default for each companion module.

## Setting up secrets

1. Generate an age identity if you do not already have one:

```bash
mkdir -p ~/.config/age
age-keygen -o ~/.config/age/keys.txt
```

If `age-keygen` is not installed, use `nix run nixpkgs#age -- keygen -o ~/.config/age/keys.txt`.

2. Add the public key to `secrets.nix`. The file lists each encrypted file and its recipients:

```nix
# secrets.nix
{
  "hosts/server/global/nginx.conf.age".publicKeys = [ alice server ];
}
```

3. Encrypt the file. Run the command from the directory that contains `secrets.nix`:

```bash
cd ~/agenix
nix run github:ryantm/agenix -- -e hosts/server/global/nginx.conf.age
```

If you set `cattery.secrets.secretsPath = ./secrets`, run the same command from that directory.

4. Add the identity to the host. On NixOS, agenix reads the host SSH keys by default. To use the key generated in step 1:

```nix
{
  age.identityPaths = [ "/home/alice/.config/age/keys.txt" ];
}
```

5. Enable the service and the secrets module:

```nix
cattery = {
  secrets.enable = true;
  services.nginx.enable = true;
};
```

The file is decrypted during activation and linked to its target, for example `/etc/nginx/conf.d/nginx.conf`.

## YubiKey support

`cattery.secrets.yubikey.enable` is declared, but the current module does not add `age-plugin-yubikey`. The package override is commented out in `modules/shared/secrets/default.nix`, so enabling the option alone does not configure a YubiKey identity. To use a YubiKey, add the plugin and the identity path through the agenix options.

## Impermanence and secrets

When `cattery.system.impermanence.enable` is set on NixOS, the module persists `/etc/ssh` and sets `age.identityPaths` to the copies under `/persistent/etc/ssh`. The host keys used by agenix then survive reboots. Decrypted secrets stay in the agenix runtime directory (normally `/run/agenix`); the impermanence module does not copy them to the persistent volume.

```nix
cattery = {
  secrets.enable = true;
  system.impermanence.enable = true;
};
```
