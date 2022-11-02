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


### [Install Automatically](https://github.com/mlyxshi/kexec)

```sh
# curl -sL https://github.com/mlyxshi/kexec/releases/download/latest/kexec-x86_64-linux | bash -s script_url=AUTORUN_SCRIPT_URL  script_arg1=SCRIPT_ARG1 script_arg2=SCRIPT_ARG2 script_arg3=SCRIPT_ARG3
# Example:
curl -sL https://github.com/mlyxshi/kexec/releases/download/latest/kexec-x86_64-linux | bash -s script_url=https://github.com/mlyxshi/flake/releases/download/latest/install-example.sh  script_arg1=AGE_KEY_URL script_arg2=TG_TOKEN script_arg3=TG_ID
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