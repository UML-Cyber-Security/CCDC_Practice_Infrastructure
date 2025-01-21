# Nix Environment Setup

## Installing nix

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
  sh -s -- install
```

## Using devenv and direnv

To install them to the system use:

```bash
nix profile install nixpkgs#direnv
nix profile install nixpkgs#devenv
```

To manually activate the shell just run:

```bash
devenv shell
```
