# Usage as a flake

[![FlakeHub](https://img.shields.io/endpoint?url=https://flakehub.com/f/nixcafe/cattery-modules/badge)](https://flakehub.com/flake/nixcafe/cattery-modules)

Add cattery-modules to your `flake.nix`:

```nix
{
  inputs.cattery-modules.url = "https://flakehub.com/f/nixcafe/cattery-modules/*.tar.gz";

  outputs = { self, cattery-modules }: {
    # Use in your outputs
  };
}

```
