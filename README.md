## Server
#### Github Action pre-build and cache
- cachix: build install script
```
nix build .#nixosConfigurations.HOST.config.system.build.install
```
- garnix: build nixos system
```
nix build .#nixosConfigurations.HOST.config.system.build.toplevel
```
#### Use your own ssh key and age key
```
bash <(curl -sL https://raw.githubusercontent.com/mlyxshi/kexec/main/prekexec.sh)
```
#### Enter kexec environment
```
bash <(curl -sL https://github.com/mlyxshi/flake/releases/download/latest/install.sh)  AGE_KEY_URL
reboot
```
#### Fix
```
# after reboot, activate sops-nix manually
/nix/var/nix/profiles/system/bin/switch-to-configuration switch
```
## First Install [Local PC]
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

# nixos-generate-config --show-hardware-config
# nixos-generate-config --root /mnt
# vim /mnt/etc/nixos/configuration.nix 

nixos-install --flake github:mlyxshi/flake#hx90 -v
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

# insatll homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# login appstore and uncomment brew mas section

# sops age private key
/Users/dominic/Library/Application Support/sops/age/keys.txt
```

## nix
```
# https://nixos.org/manual/nix/stable/installation/installing-binary.html
sh <(curl -L https://nixos.org/nix/install)

# bootstrap darwin-nix
# nix build <Flake Floder PATH>#darwinConfigurations.<HOSTNAME>.system
cd ~/flake
nix build --extra-experimental-features "nix-command flakes" ~/flake#darwinConfigurations.M1.system
./result/sw/bin/darwin-rebuild switch --flake ~/flake#M1

# https://github.com/LnL7/nix-darwin/issues/458
sudo mv /etc/nix/nix.conf  /etc/nix/nix.conf.bkup 

# Finally rebuild
darwin-rebuild switch --flake ~/flake#M1 -v
```