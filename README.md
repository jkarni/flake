## Pre: sops file
write age private key to /var/lib/sops-nix/key.txt

## 1. Normal[PC]
```
git clone git@github.com:mlyxshi/flake.git  /etc/flake
nixos-rebuild switch --flake /etc/flake#hx90
```

## 2. NixInject(Server)

Reinstall OS to Debian(fixed partition)
```
bash <(wget -qO- https://raw.githubusercontent.com/bohanyang/debi/master/debi.sh) --user root --password 12345 --authorized-keys-url https://github.com/mlyxshi.keys --version stable --filesystem ext4 --esp 538 && reboot
```

Reinstall OS to NixOS
```
apt install -y wget 
wget -qO- https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | NIX_CHANNEL=nixos-unstable  bash -x
```

Rebuild NixOS
```
nix-env -iA nixos.vim nixos.git nixos.tree
<write private key>
git clone git@github.com:mlyxshi/flake.git  /etc/flake
rm -rf /boot/*
bootctl install
nixos-rebuild switch --flake /etc/flake#oracle
```

## 3. First Install[PC]
```
fdisk /dev/nvme0n1

mkfs.fat -F32 /dev/nvme0n1p1
mkfs.ext4 /dev/nvme0n1p2

mount /dev/nvme0n1p2 /mnt
mkdir /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot

<!-- 
nixos-generate-config --root /mnt
vim /mnt/etc/nixos/configuration.nix 
-->

nix-env -iA nixos.vim nixos.git nixos.tree nixos.nixUnstable

git clone  https://github.com/mlyxshi/flake /mnt/etc/nixos 
nixos-install --flake /mnt/etc/flake#hx90
```

第一次安装sops失败，不过没关系，ssh authorized_key是明文ed25519 public key，所以可以登录
ssh登录后，配置sops

```
mkdir -p /var/lib/sops-nix/
echo "MY AGE PRIVATE KEY" > /mnt/var/lib/sops-nix/key.txt
```

```
nixos-rebuild switch --flake /etc/flake#hx90

cd /etc/falke
git remote set-url origin git@github.com:mlyxshi/flake.git
```
