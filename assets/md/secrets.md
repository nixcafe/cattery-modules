# Secrets & agenix

cattery integrates [agenix](https://github.com/ryantm/agenix) for encrypted secret management. Every service module that needs secrets has a companion `*.secrets` sub-module that auto-wires encrypted config files.

## Architecture

```
secrets/
├── hosts/<host>/global/       # host-specific, root-owned (e.g., nginx conf.d)
├── hosts/<host>/users/<user>/ # host-specific, user-owned (e.g., git config)
├── shared/global/              # shared across all hosts, root-owned
└── shared/users/<user>/       # shared across all hosts, user-owned
```

Secrets are encrypted with age and can be decrypted with SSH keys or YubiKeys.

## Enabling Secrets

```nix
{
  cattery.secrets.enable = true;

  # Optional: YubiKey support
  cattery.secrets.yubikey.enable = true;
}
```

## Service Secrets

Every service that supports secrets has a `secrets` sub-module. It auto-enables when both the parent service and `cattery.secrets` are enabled:

```nix
cattery = {
  secrets.enable = true;

  # This auto-wires encrypted config files:
  services.nginx.enable = true;     # → encrypted nginx conf.d
  services.forgejo.enable = true;   # → encrypted forgejo app.ini
  services.postgresql.enable = true;# → encrypted postgresql.conf
  services.wg-quick.enable = true;  # → encrypted wireguard configs
  services.cloudflared.enable = true; # → encrypted tunnel credentials
};
```

## Available Secret Modules

| Module | Secret Files |
|---|---|
| `cattery.secrets` | Master secrets config (hosts, shared, files) |
| `cattery.nix.secrets` | Encrypted nix config (`!include` in nix.extraOptions) |
| `cattery.services.nginx.secrets` | nginx conf.d files |
| `cattery.services.acme.secrets` | ACME DNS provider env files |
| `cattery.services.forgejo.secrets` | forgejo app.ini |
| `cattery.services.gitea.secrets` | gitea app.ini |
| `cattery.services.gitea-actions-runner.secrets` | Runner token env files |
| `cattery.services.postgresql.secrets` | postgresql.conf, pg\_hba.conf, pg\_ident.conf |
| `cattery.services.vaultwarden.secrets` | vaultwarden env file |
| `cattery.services.wg-quick.secrets` | WireGuard config files |
| `cattery.services.cloudflared.secrets` | Tunnel credential files |
| `cattery.services.sing-box.secrets` | sing-box config.json |
| `cattery.system.fileSystems.samba.secrets` | Samba credential files |
| `cattery.cli-apps.ssh.secrets` | SSH known\_hosts files |
| `cattery.cli-apps.security.gnupg.secrets` | GPG keyring files |
| `cattery.cli-apps.dev-kit.git.secrets` | Git include configs |

## Secret Scopes

Each secret is categorized by scope:

| Scope | Path pattern | Owner | Use case |
|---|---|---|---|
| `hosts-global` | `hosts/<host>/global/` | root | System-level configs (nginx, postgresql, forgejo) |
| `hosts-user` | `hosts/<host>/users/<user>/` | user | Per-user configs on specific hosts (git, GPG, SSH) |
| `shared-global` | `shared/global/` | root | System configs shared across all hosts |
| `shared-user` | `shared/users/<user>/` | user | User configs shared across all hosts |

## Example: Setting Up Secrets

1. Create your age key (once per host/user):

```bash
mkdir -p ~/.config/sops/age
nix run github:ryantm/agenix -- -e ~/.config/sops/age/keys.txt
```

2. Create a `.age` file with public keys:

```
# secrets.nix
{
  "hosts/server/global/nginx.conf.age".publicKeys = [ alice server ];
}
```

3. Encrypt your secret:

```bash
nix run github:ryantm/agenix -- -e secrets/hosts/server/global/nginx.conf.age
```

4. Enable the service — the secret is auto-mounted:

```nix
cattery = {
  secrets.enable = true;
  services.nginx.enable = true;
};
```

The encrypted file is decrypted at boot and mounted at its target path (e.g., `/etc/nginx/conf.d/nginx.conf`).

## YubiKey Support

Enable YubiKey-based decryption:

```nix
cattery.secrets.yubikey.enable = true;
```

This configures agenix to use YubiKey identities. Requires a YubiKey with an age-compatible PIV key.

## Impermanence + Secrets

When using impermanence (ephemeral root), secrets are automatically persisted. agenix decrypts at boot and the decrypted files are stored on the persistent volume.

```nix
cattery = {
  secrets.enable = true;
  system.impermanence.enable = true;
};
```
