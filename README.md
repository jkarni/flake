## Normal
```
nixos-rebuild switch --flake /etc/nixos#hx90
```



## NixInject

Reinstall OS to debian(fixed partition)
```
bash <(wget -qO- https://raw.githubusercontent.com/bohanyang/debi/master/debi.sh) --user root --password 12345 --authorized-keys-url https://github.com/mlyxshi.keys --version stable --filesystem ext4 --esp 538 && reboot
```

```
nix-env -iA nixos.vim nixos.git
<write private key>
git clone --recurse-submodules  git@github.com:mlyxshi/flake.git  /etc/flake
nix-env -iA nixos.nixUnstable
nix --experimental-features 'nix-command flakes' flake update
nixos-install --flake /etc/flake#oracle 
```

## First Install (private repo: github token)
```
<write private key>
git clone --recurse-submodules  git@github.com:mlyxshi/flake.git  /mnt/etc/nixos
nix-env -iA nixos.nixUnstable
nix --experimental-features 'nix-command flakes' flake update
nixos-install --flake /mnt/etc/nixos#hx90 
```
