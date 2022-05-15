## Normal
```
nixos-rebuild switch --flake /etc/nixos#hx90
```



## NixInject
```
<write private key>
git clone --recurse-submodules  git@github.com:mlyxshi/flake.git  /etc/nixos
nix-env -iA nixos.nixUnstable
nix --experimental-features 'nix-command flakes' flake update
nixos-install --flake /etc/nixos#server --show-trace
```

## First Install (private repo: github token)
```
<write private key>
git clone --recurse-submodules  git@github.com:mlyxshi/flake.git  /mnt/etc/nixos
nix-env -iA nixos.nixUnstable
nix --experimental-features 'nix-command flakes' flake update
nixos-install --flake /mnt/etc/nixos#hx90 --show-trace
```
