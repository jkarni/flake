#! /usr/bin/env bash

apt install -y wget kexec-tools

wget https://github.com/mlyxshi/flake/releases/download/latest/kexec-boot
wget https://github.com/mlyxshi/flake/releases/download/latest/initrd.gz
wget https://github.com/mlyxshi/flake/releases/download/latest/bzImage

chmod +x ./kexec-boot
./kexec-boot