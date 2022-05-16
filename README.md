## 1. Normal[PC]
```
nixos-rebuild switch --flake /etc/nixos#hx90
```



## 2. NixInject(Server)

Reinstall OS to Debian(fixed partition)
```
bash <(wget -qO- https://raw.githubusercontent.com/bohanyang/debi/master/debi.sh) --user root --password 12345 --authorized-keys-url https://github.com/mlyxshi.keys --version stable --filesystem ext4 --esp 538 && reboot
```

Reinstall OS to NixOS
```
apt install -y wget && wget -qO- https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | NIX_CHANNEL=nixos-unstable  bash -x
```

Rebuild NixOS
```
nix-env -iA nixos.vim nixos.git
<write private key>
git clone --recurse-submodules  git@github.com:mlyxshi/flake.git  /etc/flake
nixos-rebuild switch --flake /etc/flake#oracle
```

## 3. First Install[PC]
```
<write private key>
git clone --recurse-submodules  git@github.com:mlyxshi/flake.git  /mnt/etc/nixos
nixos-install --flake /mnt/etc/nixos#hx90 
```
