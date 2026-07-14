# CLAUDE.md

## Project Overview

**cattery-modules** is a collection of Nix modules for system and home-manager configuration, maintained by the [nixcafe](https://github.com/nixcafe) organization.

- **Repo**: https://github.com/nixcafe/cattery-modules
- **FlakeHub**: https://flakehub.com/flake/nixcafe/cattery-modules
- **Language**: Nix (flake-based)
- **Module namespace**: `cattery`
- **Supported targets**: NixOS, home-manager, nix-darwin, NixOS-WSL

## Project Structure

```
cattery-modules/
├── flake.nix              # Flake entrypoint, uses purr.lib.mkFlake
├── modules/
│   ├── darwin/            # nix-darwin specific modules
│   ├── home/              # home-manager modules
│   ├── nixos/             # NixOS modules
│   └── shared/            # Shared modules (both NixOS & home-manager)
├── lib/
│   ├── module/            # Module helper utilities
│   ├── secrets/           # agenix secret helpers
│   └── utils/             # General utilities
├── checks/                # Pre-commit check outputs (auto-generated)
├── shells/                # Dev shell definitions
└── .github/
    ├── workflows/
    │   ├── ci.yml                          # CI: nix flake check
    │   └── flakehub-publish-rolling.yml    # Auto-publish to FlakeHub
    └── PULL_REQUEST_TEMPLATE.md
```

## GitHub Flow

This project follows **GitHub Flow** with `main` as the trunk branch.

### Branch Naming

| Prefix   | Purpose       |
| -------- | ------------- |
| `feat/`  | New features  |
| `fix/`   | Bug fixes     |
| `chore/`  | Maintenance   |
| `docs/`  | Documentation |

### Workflow

1. Create a feature branch from `main`
2. Make changes and test locally:
   - `nix flake check` (lint + eval all modules)
   - `nix fmt` (format with nixfmt)
   - Test on a real machine: `nixos-rebuild test` or `home-manager switch`
3. Push branch and open a PR against `main`
4. Fill in the PR template (description + checklist)
5. CI runs `nix flake check --accept-flake-config` on every PR and push to `main`
6. Require at least one review approval before merge
7. On merge to `main`, FlakeHub auto-publishes a new rolling release

### Pre-commit Hooks

Configured via `git-hooks.nix` (auto-generated `.pre-commit-config.yaml`):

| Hook     | Purpose                           |
| -------- | --------------------------------- |
| deadnix  | Remove dead/unused Nix code       |
| nixfmt   | Format `.nix` files               |
| statix   | Lint `.nix` files (repeated_keys disabled) |

To install hooks: `nix develop` (direnv auto-loads via `.envrc`)

## Key Flake Inputs

| Input              | Purpose                                  |
| ------------------ | ---------------------------------------- |
| `purr`             | Module bundling helper (`mkFlake`)       |
| `home-manager`     | Home-manager modules                     |
| `nix-darwin`       | macOS module support                     |
| `nixos-wsl`        | WSL integration                          |
| `impermanence`     | Ephemeral root support                   |
| `agenix`           | Secret management                        |
| `lanzaboote`       | Secure Boot                              |
| `catppuccin`       | Catppuccin theming                       |
| `plasma-manager`   | KDE Plasma configuration                 |
| `nix-gaming`       | Gaming-related packages                  |
| `rust-overlay`     | Rust toolchains                          |
| `pre-commit-hooks` | Dev shell pre-commit hooks               |
| `vscode-server`    | VS Code remote server                    |
| `nix-index-database` | Command-not-found index               |

## Code Conventions

- All code and comments must be in English
- Module namespace: `cattery` (e.g., `cattery.gaming`, `cattery.themes.catppuccin`)
- Module files use `enable` option pattern for feature toggles
- Follow existing module structure: `options` → `config` with `mkIf cfg.enable`
- Use `lib.mkEnableOption` and `lib.mkIf` from the module system
- Format all Nix files with `nixfmt` before committing

## Useful Commands

```bash
nix develop              # Enter dev shell (auto via direnv)
nix flake check          # Run all checks (lint + eval)
nix fmt                  # Format all Nix files
nix flake update         # Update flake inputs
```
