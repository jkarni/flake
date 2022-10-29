## NixInfect [Server]

Reinstall OS to Debian(resize partition without entering tmpfs env)
```
bash <(wget -qO- https://raw.githubusercontent.com/bohanyang/debi/master/debi.sh) --user root --password 12345 --authorized-keys-url https://github.com/mlyxshi.keys --version stable --filesystem ext4 --esp 538 && reboot
```

Refresh Sops Settings
```
# SSH login
ssh-keyscan IP | ssh-to-age
# write to secrets/.sops.yaml
sops updatekeys key.yaml
```

Reinstall OS to NixOS
```
apt install -y wget
wget -qO- https://raw.githubusercontent.com/mlyxshi/flake/main/infect.sh | FLAKE_URL="github:mlyxshi/flake" NIXOS_CONFIG_NAME="jp2" bash -x
```