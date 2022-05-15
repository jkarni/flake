## Normal
```
nixos-rebuild switch --flake /etc/nixos#hx90
```

## First Install (private repo: github token)
```
git clone --recurse-submodules  git@github.com:mlyxshi/flake.git  /mnt/etc/nixos
nix nix-env -iA nixos.nixUnstable
nix --experimental-features 'nix-command flakes' flake update
nixos-install --flake /mnt/etc/nixos#hx90 --show-trace
```
