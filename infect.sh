infect() { 

  groupadd nixbld -g 30000 || true
  for i in {1..10}; do
    useradd -c "Nix build user $i" -d /var/empty -g nixbld -G nixbld -M -N -r -s "$(which nologin)" "nixbld$i" || true
  done

  curl -L https://nixos.org/nix/install | sh
  source ~/.nix-profile/etc/profile.d/nix.sh


  # Flake adaptations
  nix \
    --extra-experimental-features "nix-command flakes" \
  build \
    --profile /nix/var/nix/profiles/system \
    "${FLAKE_URL}#nixosConfigurations.${NIXOS_CONFIG_NAME}.config.system.build.toplevel"
  : # Code folding really suck

  # region Activate everything
  # From https://github.com/elitak/nixos-infect/blob/master/nixos-infect#L300-L323

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

infect