## Server
<details><summary>Github Action Instantiate/Evaluation System Closure outPath </summary>

#### create install script and upload to release

```sh
SYSTEM_CLOSURE=$(nix eval --raw .#nixosConfigurations.example.config.system.build.toplevel)
sed "6iSYSTEM_CLOSURE=$SYSTEM_CLOSURE"  install-template.sh > install-example.sh  
```

</details>

<details><summary>garnix: Realise/Build NixOS System and cache System Closure</summary>

[garnix](https://garnix.io/)

</details>

### Install Manually. 
```sh
# curl -sL https://raw.githubusercontent.com/mlyxshi/kexec/main/prekexec.sh | bash -s SSH_KEY
curl -sL https://raw.githubusercontent.com/mlyxshi/kexec/main/prekexec.sh \
| bash -s "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMpaY3LyCW4HHqbp4SA4tnA+1Bkgwrtro2s/DEsBcPDe"
```

```sh
# Enter kexec environment, Install NixOS
curl -sL https://github.com/mlyxshi/flake/releases/download/latest/install-example.sh \
| bash -s  AGE_KEY_URL TELEGRAM_TOKEN TELEGRAM_ID

# high-end machine can also build system closure directly
install FLAKE_URL HOST_NAME AGE_KEY_URL TELEGRAM_TOKEN TELEGRAM_ID
```

### Install Automatically

```sh
# curl -sL https://raw.githubusercontent.com/mlyxshi/kexec/main/prekexec.sh) | bash -s SSH_KEY  INSTALL_SCRIPT_URL AGE_KEY_URL TELEGRAM_TOKEN TELEGRAM_ID
curl -sL https://raw.githubusercontent.com/mlyxshi/kexec/main/prekexec.sh \
| bash -s  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMpaY3LyCW4HHqbp4SA4tnA+1Bkgwrtro2s/DEsBcPDe" \
https://github.com/mlyxshi/flake/releases/download/latest/install-example.sh  \
AGE_KEY_URL TELEGRAM_TOKEN TELEGRAM_ID
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