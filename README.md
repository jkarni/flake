## Server
<details><summary>Github Action Instantiate/Evaluation System Closure drvPath</summary>

#### create install script and upload to release

```sh
SYSTEM_CLOSURE=$(nix eval --raw .#nixosConfigurations.us0.config.system.build.toplevel)
sed "6iSYSTEM_CLOSURE=$SYSTEM_CLOSURE"  install-template.sh > install-us0.sh  
```

</details>

<details><summary>garnix: Realise/Build NixOS System and cache System Closure</summary>

```sh
nix build .#nixosConfigurations.HOST.config.system.build.toplevel
```

</details>

#### Enter kexec environment. Use your own SSH key
```sh
bash <(curl -sL https://raw.githubusercontent.com/mlyxshi/kexec/main/prekexec.sh)
```
#### Install NixOS. Use your own AGE key
- 1C 512M need pre build
```sh
bash <(curl -sL https://github.com/mlyxshi/flake/releases/download/latest/install-HOST.sh)  AGE_KEY_URL
```
- 4C 24G install directly
```sh
install FLAKE_URL HOST_NAME AGE_KEY_URL
```
#### Reboot and Fix
```sh
# after reboot, activate sops-nix manually
/nix/var/nix/profiles/system/bin/switch-to-configuration switch
```
---
# Darwin
## pre
```sh
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
```sh
# https://nixos.org/manual/nix/stable/installation/installing-binary.html
sh <(curl -L https://nixos.org/nix/install)

# bootstrap darwin-nix
cd ~/flake
nix build --extra-experimental-features "nix-command flakes" ~/flake#darwinConfigurations.M1.system
./result/sw/bin/darwin-rebuild switch --flake ~/flake#M1

# https://github.com/LnL7/nix-darwin/issues/458
sudo mv /etc/nix/nix.conf  /etc/nix/nix.conf.bkup 

# Finally rebuild
darwin-rebuild switch --flake ~/flake#M1 -v
```