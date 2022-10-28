#! /usr/bin/env bash

# install  bzImage initrd.gz kexec-boot
apt install -y jq wget kexec-tools
kexec_files=$(curl --silent "https://api.github.com/repos/mlyxshi/flake/releases/latest"| jq ."assets[].browser_download_url" | tr -d '"')

for i in $kexec_files
do
    wget ${i}
done


nixos-install --root /mnt --flake github:mlyxshi/flake#us0 \
--no-channel-copy --no-root-passwd \
--option trusted-public-keys "mlyxshi.cachix.org-1:yc7GPiryyBn0HfiCXdmO1ECWKBhfwrjdIFnRSA4ct7s=" \
--option substituters "https://mlyxshi.cachix.org" -v