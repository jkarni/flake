#! /usr/bin/env bash
set -e

FLAKE_URL=$1
HOST_NAME=$2
KEY_URL=$3
sfdisk /dev/sda <<EOT
label: gpt
type="EFI System",        name="BOOT",  size=512M
type="Linux filesystem", name="NIXOS", size=+
EOT
sleep 3
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2
mkdir /mnt
mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

mkdir -p /mnt/var/lib/sops/   
curl -s "$KEY_URL" -o /mnt/var/lib/sops/age.key
nixos-install --root /mnt --flake "$FLAKE_URL"#"$HOST_NAME" \
--no-channel-copy --no-root-passwd \
--option trusted-public-keys "mlyxshi.cachix.org-1:yc7GPiryyBn0HfiCXdmO1ECWKBhfwrjdIFnRSA4ct7s= cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" \
--option substituters "https://mlyxshi.cachix.org https://cache.garnix.io" -v 
if [[ -n "$4" && -n "$5" ]]; then
MESSAGE="<b>Install NixOS Completed</b>%0A$HOST_NAME"
URL="https://api.telegram.org/bot$4/sendMessage"
curl -X POST "$URL" -d chat_id="$5" -d text="$MESSAGE" -d parse_mode=html
fi
reboot