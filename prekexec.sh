#! /usr/bin/env bash

apt install -y jq wget curl kexec-tools

kexec_files=$(curl --silent "https://api.github.com/repos/mlyxshi/flake/releases/latest"| jq ."assets[].browser_download_url" | tr -d '"')

for i in $kexec_files
do
    wget ${i}  # install /bzImage /initrd.gz /kexec-boot
done

chmod +x ./kexec-boot
./kexec-boot