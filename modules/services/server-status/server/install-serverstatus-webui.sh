if [ ! -d /var/lib/ServerStatus/hotaru-theme/json ]
then
  mkdir -p /var/lib/ServerStatus/
  wget -P /var/lib/ServerStatus/ https://github.com/cokemine/hotaru_theme/releases/latest/download/hotaru-theme.zip
  unzip -d /var/lib/ServerStatus/ /var/lib/ServerStatus/hotaru-theme.zip
fi
