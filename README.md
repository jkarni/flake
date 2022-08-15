## 1. Normal[PC]
```
# git clone https://github.com/mlyxshi/flake /etc/flake
git clone github.com:mlyxshi/flake /etc/flake 
nixos-rebuild switch --flake /etc/flake#hx90 -v
```

## 2. NixInject(Server)

Reinstall OS to Debian(fix partition without entering tmpfs env)
```
bash <(wget -qO- https://raw.githubusercontent.com/bohanyang/debi/master/debi.sh) --user root --password 12345 --authorized-keys-url https://github.com/mlyxshi.keys --version stable --filesystem ext4 --esp 538 && reboot
```

Reinstall OS to NixOS
```
apt install -y wget 
wget -qO- https://raw.githubusercontent.com/mlyxshi/nixos-infect/master/nixos-infect | NIX_CHANNEL=nixos-unstable  bash -x
```

Refresh Sops Settings
```
# SSH login
ssh-keyscan xxx.mlyxshi.com | ssh-to-age
# write to modules/secrets/.sops.yaml
sops updatekeys key.yaml
```
Rebuild NixOS
```
# If EFI, delete default grub boot, use systemd-boot instead
rm -rf /boot/*
nixos-rebuild switch --flake github:mlyxshi/flake#<NAME> --install-bootloader -v
```

## 3. First Install[PC]
```
#nixos@nixos
passwd 
> 12345

ssh nixos@ip
sudo -i

fdisk /dev/nvme0n1

mkfs.fat -F32 /dev/nvme0n1p1
mkfs.ext4 /dev/nvme0n1p2

mount /dev/nvme0n1p2 /mnt
mkdir /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot

 
# nixos-generate-config --root /mnt
# vim /mnt/etc/nixos/configuration.nix 


nix-env -iA nixos.git

git clone  https://github.com/mlyxshi/flake /mnt/etc/flake 
nixos-install --flake /mnt/etc/flake#hx90 -v
```

```
nixos-rebuild switch --flake /etc/flake#hx90 -v

cd /etc/falke
git remote set-url origin github.com:mlyxshi/flake 
```


# Darwin
## pre
```
# disbale gatekeeper
sudo spctl --master-disable 
csrutil status

# Recovery  <-- shut down + long press start 
csrutil disable

# disable spotlight 
sudo mdutil -a -i off

xcode-select --install

#insatll homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# login appstore and uncomment brew mas section

# sops age private key
/Users/dominic/Library/Application Support/sops/age/keys.txt
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
darwin-rebuild switch --flake ~/flake#M1 -v
```


# Disclaimer
```
Darwin is my main OS. 
```
