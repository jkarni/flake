#! /usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

KEY_URL=$1

sfdisk /dev/sda <<EOT
label: gpt
type="EFI System",        name="BOOT",  size=512M
type="Linux filesystem", name="NIXOS", size=+
EOT

sleep 3

mkfs.fat -F32 /dev/sda1
mkfs.ext4 -F /dev/sda2

mkdir /mnt
mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

mkdir -p /mnt/var/lib/sops/
curl -s "$KEY_URL" -o /mnt/var/lib/sops/age.key

nixos-install --root /mnt --system $SYSTEM_CLOSURE \
--no-channel-copy --no-root-passwd \
--option trusted-public-keys "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" \
--option substituters "https://cache.garnix.io" -v


if [[ -n "$2" && -n "$3" ]]; then
   MESSAGE="<b>Install NixOS Completed</b>%0A$SYSTEM_CLOSURE"
   URL="https://api.telegram.org/bot$2/sendMessage"
   curl -X POST $URL -d chat_id=$3 -d text="$MESSAGE" -d parse_mode=html
fi

reboot