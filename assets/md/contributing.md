# Contributing

cattery-modules follows [GitHub Flow](https://docs.github.com/en/get-started/using-github/github-flow) with `main` as the trunk branch.

## Development environment

```bash
git clone https://github.com/nixcafe/cattery-modules.git
cd cattery-modules
nix develop
```

The dev shell provides:

| Tool | Purpose |
|---|---|
| `nixfmt` | Nix code formatter |
| `deadnix` | Find dead or unused Nix code |
| `statix` | Lint Nix files (`repeated_keys` disabled) |

The shell hook installs the pre-commit hooks. If you use direnv, `direnv allow` loads the same shell.

## Project structure

```
cattery-modules/
├── flake.nix                  # Flake entrypoint using purr.lib.mkFlake
├── modules/
│   ├── nixos/                 # NixOS modules
│   │   ├── room/              # Room profiles
│   │   ├── services/          # Services (nginx, postgresql, ...)
│   │   ├── desktop/           # Compositors, themes, display managers
│   │   ├── apps/              # NixOS-side application modules
│   │   ├── cli-apps/          # NixOS-side CLI modules
│   │   ├── system/            # Boot, GPU, network, locale, file systems
│   │   ├── security/          # PAM
│   │   └── containers/        # Declarative NixOS containers
│   ├── home/                  # home-manager modules
│   │   ├── room/              # Home-manager room profiles
│   │   ├── shared/            # Cross-platform home modules
│   │   ├── nixos/             # NixOS-specific home modules
│   │   └── darwin/            # Darwin-specific home modules
│   ├── darwin/                # nix-darwin modules
│   └── shared/                # Modules shared between module sets
├── lib/
│   ├── module/                # mkDefaultEnabled, mkDefaultDisabled
│   ├── secrets/               # agenix helper functions
│   └── utils/                 # General utilities
├── shells/                    # Dev shell definition
└── checks/                    # git-hooks and module-eval checks
```

## Module conventions

Most modules follow this shape:

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

### Key conventions

* **Namespace**: Use `${namespace}`. The flake sets it to `cattery`.
* **Enable option**: Most modules have an `enable` option.
* **extraOptions**: Many modules expose `extraOptions = mkOption { type = attrs; default = { }; }` and merge it into the underlying options.
* **persistence**: Many home-manager modules that write state have a `persistence` option, default `true`.
* **Platform checks**: Use `purr.meta.isLinux` and `purr.meta.isDarwin` for platform-specific code.
* **Rooms**: Use `mkDefaultEnabled` from `lib.cattery.module` for sub-module enables.

## Branch naming

| Prefix | Purpose |
|---|---|
| `feat/` | New features or modules |
| `fix/` | Bug fixes |
| `chore/` | Maintenance and dependency updates |
| `docs/` | Documentation |

## Workflow

1. Create a branch from `main`.

2. Make changes.

3. Test locally:

   ```bash
   nix flake check     # lint and evaluate all 262 modules
   nix fmt             # format all files
   ```

4. Optionally test on a real machine:

   ```bash
   nixos-rebuild test --flake .#myhost
   home-manager switch --flake .#alice
   ```

5. Push the branch and open a pull request against `main`.

6. Get at least one review approval.

7. On merge to `main`, FlakeHub publishes a new rolling release.

## CI

Pull requests to `main` run `nix flake check`. The check includes:

* **nixfmt**: format check
* **deadnix**: dead code check
* **statix**: lint check
* **module-eval**: import and call check for all 262 module files

A push to `main` triggers the FlakeHub workflow, which publishes a rolling release at `nixcafe/cattery-modules`.

## Adding a module

1. Create the module file in the appropriate directory:
   * NixOS: `modules/nixos/<category>/<name>/default.nix`
   * Shared between module sets: `modules/shared/<category>/<name>/default.nix`
   * Cross-platform home-manager: `modules/home/shared/<category>/<name>/default.nix`
   * NixOS-specific home-manager: `modules/home/nixos/<category>/<name>/default.nix`
   * Darwin-specific home-manager: `modules/home/darwin/<category>/<name>/default.nix`

2. Add `enable` and any module-specific options. Add `extraOptions` when the module wraps a NixOS or home-manager option set.

3. If the module needs secrets, add a companion `secrets/default.nix` and use `mkAppSecretsOption` or `mkHomeAppSecretsOption` from `lib.cattery.secrets`.

4. Add the module to a room when appropriate. Use `mkDefaultEnabled` for sub-module enables.

5. Run `nix flake check` and `nix fmt`.

## Branch protection

* Pull request reviews are required (at least one approval).
* Status checks must pass before merging.
* Stale reviews are dismissed when new commits are pushed.
