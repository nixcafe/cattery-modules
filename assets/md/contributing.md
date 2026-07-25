# Contributing

cattery-modules follows [GitHub Flow](https://docs.github.com/en/get-started/using-github/github-flow) with `main` as the trunk branch.

## Development Environment

```bash
git clone https://github.com/nixcafe/cattery-modules.git
cd cattery-modules
nix develop     # enters dev shell (or direnv allow)
```

The dev shell provides:

| Tool | Purpose |
|---|---|
| `nixfmt` | Nix code formatter |
| `deadnix` | Remove dead/unused Nix code |
| `statix` | Lint Nix files (`repeated_keys` disabled) |

Pre-commit hooks install automatically on `nix develop`.

## Project Architecture

```
cattery-modules/
├── flake.nix                  # Flake entrypoint using purr.lib.mkFlake
├── modules/
│   ├── nixos/                 # NixOS-specific modules
│   │   ├── room/              # Room profiles (composite module bundles)
│   │   ├── services/          # System services (nginx, postgresql, ...)
│   │   ├── desktop/           # Desktop environments & themes
│   │   ├── apps/              # GUI applications
│   │   ├── cli-apps/          # CLI tools & dev kits
│   │   ├── system/            # Boot, GPU, network, locale, ...
│   │   ├── security/          # PAM, firewall
│   │   └── containers/        # Declarative NixOS containers
│   ├── home/                  # home-manager modules
│   │   ├── shared/            # Cross-platform home modules
│   │   ├── nixos/             # NixOS-specific home modules
│   │   └── darwin/            # Darwin-specific home modules
│   ├── darwin/                # nix-darwin modules
│   └── shared/                # Shared between NixOS and darwin
├── lib/
│   ├── module/                # mkDefaultEnabled, mkDefaultDisabled
│   ├── secrets/               # agenix helper utilities
│   └── utils/                 # General utilities
├── shells/                    # Dev shell definition
└── checks/                    # git-hooks + module-eval checks
```

## Module Conventions

Every module follows the same pattern:

```nix
{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  cfg = config.${namespace}.my-module;
in
{
  options.${namespace}.my-module = {
    enable = lib.mkEnableOption "my module";
    # ... other options
  };

  config = lib.mkIf cfg.enable {
    # ... implementation
  };
}
```

### Key Conventions

* **Namespace**: Always use `${namespace}` — maps to `cattery`
* **Enable pattern**: Every module has an `enable` option
* **extraOptions**: Every module exposes `extraOptions = mkOption { type = attrs; default = {}; }` for extensibility
* **persistence**: Home-manager modules with state use a `persistence` option (default `true`)
* **Platform gating**: Use `config.purr.isLinux` / `config.purr.isDarwin` for platform-specific logic
* **Rooms**: Use `mkDefaultEnabled` from `lib.cattery.module` for sub-module enables in room profiles

## Branch Naming

| Prefix | Purpose |
|---|---|
| `feat/` | New features or modules |
| `fix/` | Bug fixes |
| `chore/` | Maintenance, dependency updates |
| `docs/` | Documentation |

## Workflow

1. Create a feature branch from `main`
2. Make changes
3. Test locally:
   ```bash
   nix flake check     # lint + eval all 244+ modules
   nix fmt             # format all files
   ```
4. Optionally test on a real machine:
   ```bash
   nixos-rebuild test --flake .#myhost
   home-manager switch --flake .#alice
   ```
5. Push and open a PR against `main`
6. **Require at least one review approval** before merge
7. On merge to `main`, FlakeHub auto-publishes a new rolling release

## CI/CD

### Pull Requests

`nix flake check --accept-flake-config` runs on every PR. This includes:

* **nixfmt** — format check
* **deadnix** — dead code check
* **statix** — lint check
* **module-eval** — import & call check for all 244+ modules

### Push to Main

FlakeHub automatically publishes a new rolling release at `nixcafe/cattery-modules`.

## Adding a New Module

1. Create the module file under the appropriate directory:
   * NixOS-only: `modules/nixos/<category>/<name>/default.nix`
   * cross-platform home: `modules/home/shared/<category>/<name>/default.nix`
   * NixOS-specific home: `modules/home/nixos/<category>/<name>/default.nix`

2. Follow the standard pattern with `enable`, `extraOptions`, and `persistence` (for stateful home modules)

3. If the module needs secrets, add a companion `secrets/default.nix` using `mkAppSecretsOption` / `mkHomeAppSecretsOption` from `lib.cattery.secrets`

4. Add to a room if appropriate — use `mkDefaultEnabled` for sub-module enables

5. Run `nix flake check` and `nix fmt`

## Branch Protection

* Pull request reviews are required (at least 1 approval)
* Status checks must pass before merging
* Stale reviews are dismissed when new commits are pushed
