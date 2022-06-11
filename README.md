## Pre: sops file
write age private key to /var/lib/sops-nix/key.txt

## 1. Normal[PC]
```
git clone github.com:mlyxshi/flake /etc/flake
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
git clone https://github.com/mlyxshi/flake /etc/flake
# delete default grub boot, use systemd-boot instead
rm -rf /boot/*
nixos-rebuild switch --flake /etc/flake#oracle --install-bootloader
```

## 3. First Install[PC]
```
fdisk /dev/nvme0n1

mkfs.fat -F32 /dev/nvme0n1p1
mkfs.ext4 /dev/nvme0n1p2

mount /dev/nvme0n1p2 /mnt
mkdir /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot

 
# nixos-generate-config --root /mnt
# vim /mnt/etc/nixos/configuration.nix 


nix-env -iA nixos.vim nixos.git nixos.tree nixos.nixUnstable

git clone  https://github.com/mlyxshi/flake /mnt/etc/flake 
nixos-install --flake /mnt/etc/flake#hx90
```

第一次安装, sops配置失败，不过没关系，ssh authorized_key是明文ed25519 public key，所以可以登录

ssh登录后，配置sops

```
mkdir -p /var/lib/sops-nix/
echo "MY AGE PRIVATE KEY" > /var/lib/sops-nix/key.txt
```

```
nixos-rebuild switch --flake /etc/flake#hx90

cd /etc/falke
git remote set-url origin github.com:mlyxshi/flake
```


# Darwin
## pre
```

xcode-select --install

#insatll homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# login appstore and uncomment brew mas section
```

## nix
```
# https://nixos.org/manual/nix/stable/installation/installing-binary.html
sh <(curl -L https://nixos.org/nix/install)

nix-env -iA nixpkgs.nixUnstable

# bootstrap darwin-nix
# nix build <Flake Floder PATH>#darwinConfigurations.<HOSTNAME>.system
cd ~/flake
nix build ~/flake#darwinConfigurations.M1.system
./result/sw/bin/darwin-rebuild switch --flake ~/flake#M1

# https://github.com/LnL7/nix-darwin/issues/458
sudo mv /etc/nix/nix.conf  /etc/nix/nix.conf.bkup 

# Finally rebuild
darwin-rebuild switch --flake ~/flake#M1
```


# FAQ
```
Darwin is my main OS. 
Therefore, I will not use {xdg.configFile."file".source} to manage config  <-- Everytime I make a minor change, I have to rebuild my MacOS
Insteed, I decide to use the conventional and undeterministic way in MacOS <-- Simple symbolic link
```
