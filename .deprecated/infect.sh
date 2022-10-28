#! /usr/bin/env bash
# More info at: https://github.com/elitak/nixos-infect
# Please Run on Ubuntu/Debian

set -e -o pipefail

checkExistingSwap() {
  SWAPSHOW=$(swapon --show --noheadings --raw)
  zramswap=true
  swapcfg=""
  if [[ -n "$SWAPSHOW" ]]; then
    SWAP_DEVICE="${SWAPSHOW%% *}"
    if [[ "$SWAP_DEVICE" == "/dev/"* ]]; then
      zramswap=false
      swapcfg="swapDevices = [ { device = \"${SWAP_DEVICE}\"; } ];"
      NO_SWAP=true 
    fi
  fi
}

makeSwap() {
  swapFile=$(mktemp /tmp/nixos-infect.XXXXX.swp)
  dd if=/dev/zero "of=$swapFile" bs=1M count=$((1*1024))
  chmod 0600 "$swapFile"
  mkswap "$swapFile"
  swapon -v "$swapFile"
}

removeSwap() {
  swapoff -a
  rm -vf /tmp/nixos-infect.*.swp
}

isEFI() {
  [ -d /sys/firmware/efi ]
}

findESP() {
  esp=""
  for d in /boot/EFI /boot/efi /boot; do
    [[ ! -d "$d" ]] && continue
    [[ "$d" == "$(df "$d" --output=target | sed 1d)" ]] \
      && esp="$(df "$d" --output=source | sed 1d)" \
      && break
  done
  [[ -z "$esp" ]] && { echo "ERROR: No ESP mount point found"; return 1; }
  for uuid in /dev/disk/by-uuid/*; do
    [[ $(readlink -f "$uuid") == "$esp" ]] && echo $uuid && return 0
  done
}

prepareEnv() {

  apt install -y curl wget xz-utils sudo bzip2
  
  # $esp and $grubdev are used in makeConf()
  if isEFI; then
    esp="$(findESP)"
  else
    for grubdev in /dev/vda /dev/sda /dev/xvda /dev/nvme0n1 ; do [[ -e $grubdev ]] && break; done
  fi

  # Retrieve root fs block device
  #                   (get root mount)  (get partition or logical volume)
  rootfsdev=$(mount | grep "on / type" | awk '{print $1;}')
  rootfstype=$(df $rootfsdev --output=fstype | sed 1d)

  # DigitalOcean doesn't seem to set USER while running user data
  export USER="root"
  export HOME="/root"

  # Nix installer tries to use sudo regardless of whether we're already uid 0
  #which sudo || { sudo() { eval "$@"; }; export -f sudo; }
  # shellcheck disable=SC2174
  mkdir -p -m 0755 /nix
}


infect() {
  # Add nix build users
  # FIXME run only if necessary, rather than defaulting true
  groupadd nixbld -g 30000 || true
  for i in {1..10}; do
    useradd -c "Nix build user $i" -d /var/empty -g nixbld -G nixbld -M -N -r -s "$(which nologin)" "nixbld$i" || true
  done
  # TODO use addgroup and adduser as fallbacks
  #addgroup nixbld -g 30000 || true
  #for i in {1..10}; do adduser -DH -G nixbld nixbld$i || true; done

  curl -L https://nixos.org/nix/install | sh

  # shellcheck disable=SC1090
  source ~/.nix-profile/etc/profile.d/nix.sh

  nix --extra-experimental-features "nix-command flakes" \
    --profile /nix/var/nix/profiles/system \
    --option trusted-public-keys "mlyxshi.cachix.org-1:yc7GPiryyBn0HfiCXdmO1ECWKBhfwrjdIFnRSA4ct7s=" \
    --option substituters "https://mlyxshi.cachix.org"  \
    build "${FLAKE_URL}#nixosConfigurations.${NIXOS_CONFIG_NAME}.config.system.build.toplevel" -v -L

  # Remove nix installed with curl | bash
  rm -fv /nix/var/nix/profiles/default*
  /nix/var/nix/profiles/system/sw/bin/nix-collect-garbage

  # Reify resolv.conf
  [[ -L /etc/resolv.conf ]] && mv -v /etc/resolv.conf /etc/resolv.conf.lnk && cat /etc/resolv.conf.lnk > /etc/resolv.conf

  # Stage the Nix coup d'état
  touch /etc/NIXOS
  echo etc/nixos                  >> /etc/NIXOS_LUSTRATE
  echo etc/resolv.conf            >> /etc/NIXOS_LUSTRATE
  echo root/.nix-defexpr/channels >> /etc/NIXOS_LUSTRATE
  (cd / && ls etc/ssh/ssh_host_*_key* || true) >> /etc/NIXOS_LUSTRATE

  rm -rf /boot.bak
  isEFI && umount "$esp"

  mv -v /boot /boot.bak || { cp -a /boot /book.bak ; rm -rf /boot/* ; umount /boot ; }
  if isEFI; then
    mkdir -p /boot
    mount "$esp" /boot
    find /boot -depth ! -path /boot -exec rm -rf {} +
  fi
  NIXOS_INSTALL_BOOTLOADER=1 /nix/var/nix/profiles/system/bin/switch-to-configuration boot
}


if [[ -z "${FLAKE_URL:=$1}" ]]; then
  echo "Flake URL required!"
  exit 1
fi
if [[ -z "${NIXOS_CONFIG_NAME:=$2}" ]]; then
  echo "Desired NixOS Configuration Name required"
  exit 1
fi

prepareEnv
checkExistingSwap
if [[ -z "$NO_SWAP" ]]; then
    makeSwap # smallest (512MB) droplet needs extra memory!
fi

infect
if [[ -z "$NO_SWAP" ]]; then
    removeSwap
fi

echo "Please Reboot Manually"