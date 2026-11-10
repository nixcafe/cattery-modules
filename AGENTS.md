# AGENTS.md

## Project overview

cattery-modules is a Nix flake maintained by the [nixcafe](https://github.com/nixcafe) organization. It provides the `cattery` module namespace for NixOS, home-manager, and nix-darwin, including platform modules for NixOS-WSL and Proxmox LXC.

- Repository: https://github.com/nixcafe/cattery-modules
- FlakeHub: https://flakehub.com/flake/nixcafe/cattery-modules
- Language: Nix, using `purr.lib.mkFlake`
- Module namespace: `cattery`
- Module outputs: `nixosModules`, `homeModules`, `darwinModules`

The `modules/` tree contains 262 `.nix` files, including room definitions and secret helpers. The module-eval check imports and calls every one of them.

## Repository layout

```
cattery-modules/
├── flake.nix              # Flake entrypoint, uses purr.lib.mkFlake
├── modules/
│   ├── darwin/            # nix-darwin modules
│   ├── home/              # home-manager modules
│   ├── nixos/             # NixOS modules
│   └── shared/            # Modules loaded by both NixOS and nix-darwin
├── lib/
│   ├── module/            # Module helpers such as mkDefaultEnabled
│   ├── secrets/           # agenix secret helpers
│   └── utils/             # General utilities
├── checks/
│   ├── git-hooks/         # Pre-commit hook definitions
│   └── module-eval/       # Imports and calls every module file
├── shells/                # Development shell
└── .github/
    ├── workflows/
    │   ├── ci.yml                          # CI: nix flake check
    │   └── flakehub-publish-rolling.yml    # Publish main to FlakeHub
    └── PULL_REQUEST_TEMPLATE.md
```

`modules/home/shared` groups home-manager modules used on both Linux and macOS. Platform-specific home modules live under `modules/home/nixos` and `modules/home/darwin`. This is separate from `modules/shared`, which is loaded by both the NixOS and nix-darwin module sets.

## Flake outputs

- `nixosModules.default` imports every module under `modules/nixos` and `modules/shared`, plus the third-party modules listed in `extraModules.nixos`.
- `homeModules.default` imports every module under `modules/home`, plus the third-party modules listed in `extraModules.home`.
- `darwinModules.default` imports every module under `modules/darwin` and `modules/shared`, plus the third-party modules listed in `extraModules.darwin`.
- Each output also exposes modules by category, for example `nixosModules.services`, `homeModules.cli-apps`, and `darwinModules.system`.
- `lib.cattery.module`, `lib.cattery.secrets`, and `lib.cattery.utils` contain the helper functions.

## Rooms

Rooms live in `modules/nixos/room`, `modules/home/room`, and `modules/darwin/room`.

- NixOS defines 11 rooms: `room.basis`, `room.general`, `room.container`, `room.server-mini`, `room.server`, `room.server.nas`, `room.desktop.basis`, `room.desktop.general`, `room.desktop.dev`, `room.desktop.game`, and `room.desktop.wsl`.
- home-manager defines the same 11 rooms plus `room.game`.
- nix-darwin defines `room.basis` and `room.desktop.dev`.

Room modules enable their submodules with `lib.mkDefault` (usually through `lib.cattery.module.mkDefaultEnabled`), so a user setting takes precedence over a room default.

## GitHub flow

This project uses `main` as the trunk branch. Changes go through a branch and a pull request.

### Branch naming

| Prefix   | Purpose       |
| -------- | ------------- |
| `feat/`  | New features  |
| `fix/`   | Bug fixes     |
| `chore/` | Maintenance   |
| `docs/`  | Documentation |

### Workflow

1. Create a branch from `main`.
2. Make the change.
3. Run `nix fmt` and `nix flake check`.
4. Test the change on a machine when it affects a configuration: `nixos-rebuild test`, `home-manager switch`, or `darwin-rebuild switch`.
5. Push the branch and open a pull request against `main`.
6. Fill in the PR template.
7. CI runs `nix flake check` on every pull request and every push to `main`.
8. Wait for review before merging.
9. A push to `main` publishes a new rolling release to FlakeHub.

## Checks and pre-commit hooks

`checks/git-hooks/default.nix` configures the hooks through `git-hooks.nix`. The `.pre-commit-config.yaml` file is generated from that configuration.

| Hook     | Purpose                                    |
| -------- | ------------------------------------------ |
| `deadnix` | Remove dead or unused Nix code            |
| `nixfmt`  | Format `.nix` files                       |
| `statix`  | Lint `.nix` files (repeated keys disabled) |

`nix develop` installs the hooks through the shell hook. The `.envrc` file loads the same shell through direnv.

`checks/module-eval/default.nix` imports and calls every `.nix` file under `modules/nixos`, `modules/shared`, `modules/home`, and `modules/darwin`. It fails if a file cannot be imported or called, and reports the total number of files it checked.

## Key flake inputs

| Input                | Purpose                                      |
| -------------------- | -------------------------------------------- |
| `nixpkgs`            | nixpkgs (nixos-unstable)                     |
| `purr`               | Flake framework and module bundling          |
| `home-manager`       | home-manager modules                         |
| `darwin`             | nix-darwin modules                           |
| `nixos-wsl`          | WSL integration                              |
| `impermanence`       | Ephemeral root support                       |
| `agenix`             | Secret management                            |
| `lanzaboote`         | Secure Boot                                  |
| `catppuccin`         | Catppuccin theming                           |
| `caelestia-shell`    | Caelestia Hyprland shell                     |
| `plasma-manager`     | KDE Plasma configuration                     |
| `nix-gaming`         | PipeWire low-latency and gaming packages     |
| `rust-overlay`       | Rust toolchains                              |
| `git-hooks`          | Pre-commit hooks                             |
| `vscode-server`      | VS Code remote server                        |
| `nix-index-database` | Command-not-found index                      |
| `develop-templates`  | Development templates used by the Nix module |

## Code conventions

- Write code and comments in English.
- Use the `cattery` namespace for options, for example `cattery.services.nginx` and `cattery.desktop.hyprland`.
- Feature modules expose an `enable` option and guard their configuration with `lib.mkIf cfg.enable`.
- Use `lib.mkEnableOption` and `lib.mkIf` from the module system.
- Enable room submodules with `lib.mkDefault`, usually through `lib.cattery.module.mkDefaultEnabled`.
- Put secret helper options in a `secrets/default.nix` file next to the service module.
- Add `extraOptions` to modules that wrap another service or program when users need to pass through configuration.
- Run `nix fmt` before committing.

## Useful commands

```bash
nix develop              # Enter the dev shell (also loaded by direnv)
nix flake check          # Run hooks and evaluate every module file
nix fmt                  # Format all Nix files
nix flake update         # Update flake inputs
```
