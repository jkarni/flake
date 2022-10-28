#! /usr/bin/env bash

# install  bzImage initrd.gz kexec-boot
apt install -y jq wget kexec-tools
kexec_files=$(curl --silent "https://api.github.com/repos/mlyxshi/flake/releases/latest"| jq ."assets[].browser_download_url" | tr -d '"')

for i in $kexec_files
do
    wget ${i}
done