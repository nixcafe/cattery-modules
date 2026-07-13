# cattery-modules

[![FlakeHub](https://img.shields.io/endpoint?url=https://flakehub.com/f/nixcafe/cattery-modules/badge)](https://flakehub.com/flake/nixcafe/cattery-modules)

Nix modules for system and home-manager configuration.

## Usage

```nix
{
  inputs.cattery-modules.url = "https://flakehub.com/f/nixcafe/cattery-modules/*.tar.gz";

  outputs = { self, cattery-modules, ... }: {
    # Use in your outputs
  };
}
```

## Contributing

This project follows **GitHub Flow**:

1. Create a feature branch from `main`:
   ```
   feat/some-feature
   fix/some-bug
   chore/some-cleanup
   ```
2. Make your changes and test locally (`nixos-rebuild test` / `home-manager switch`)
3. Run `nix flake check` and `nix fmt`
4. Open a pull request against `main`
5. Wait for CI to pass and at least one review approval

### Branch naming

| Prefix   | Purpose          |
| -------- | ---------------- |
| `feat/`  | New features     |
| `fix/`   | Bug fixes        |
| `chore/` | Maintenance      |
| `docs/`  | Documentation    |

### Development

```bash
nix develop  # enter dev shell with formatters and pre-commit hooks
```
