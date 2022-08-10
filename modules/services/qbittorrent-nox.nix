{ pkgs
, lib
, config
, ...
}:
let
  cfg = config.services.qbittorrent-nox;
  qbConfigDir = "/var/lib/qbittorrent-nox";
  #  Run external program on torrent completion
  # /run/current-system/sw/bin/qbScript "%N" "%F" "%C" "%Z" "%I" "%L"
  qbScript = pkgs.writeShellScriptBin "qbScript" ''
    torrent_name=$1
    content_dir=$2
    files_num=$3
    torrent_size=$4
    file_hash=$5
    torrent_category=$6
    qb_web_url="localhost:8080"
    rclone_dest="googleshare:Download"
    log_dir="${qbConfigDir}/qBLog"
    rclone_parallel="32"
    # For upload_category, after download, upload to googledrive but do not auto delete(important resource, PT share ratio requirement)
    upload_category="upload"
    if [ ! -d $log_dir ]
    then
      mkdir -p $log_dir
    fi
    check_category(){
        if [ "$torrent_category" == $upload_category ]
        then
          echo "[$(date '+%Y-%m-%d %H:%M:%S')] Detect Upload Category" >> $log_dir/qb.log
        else
          echo "[$(date '+%Y-%m-%d %H:%M:%S')] Not Upload Category" >> $log_dir/qb.log
        fi
    }
    rclone_copy(){
        if [ -f "$content_dir" ]
        then
          ${pkgs.rclone}/bin/rclone --config ${config.sops.secrets.rclone-config.path} -v copy --log-file  $log_dir/rclone.log "$content_dir" $rclone_dest
        elif [ -d "$content_dir" ]
        then
          ${pkgs.rclone}/bin/rclone --config ${config.sops.secrets.rclone-config.path} -v copy --transfers $rclone_parallel --log-file $log_dir/rclone.log "$content_dir" $rclone_dest/"$torrent_name"
        fi
        echo -e "-------------------------------------------------------------\n" >> $log_dir/rclone.log
    }
    qb_del(){
        if [ $torrent_category == $upload_category ]
        then
          echo "[$(date '+%Y-%m-%d %H:%M:%S')] Upload Category: Do Not Auto-delete" >> $log_dir/qb.log
        else
          ${pkgs.curl}/bin/curl -X POST -d "hashes=$file_hash&deleteFiles=true" "$qb_web_url/api/v2/torrents/delete"
          echo "[$(date '+%Y-%m-%d %H:%M:%S')] Auto-delete Success" >> $log_dir/qb.log
        fi
    }
    telegram(){
        TOKEN=$(cat ${config.sops.secrets.tg-notify-token.path})
        CHAT_ID=$(cat ${config.sops.secrets.tg-userid.path})
        MESSAGE="$torrent_name GoogleDrive Upload Success"
        URL="https://api.telegram.org/bot$TOKEN/sendMessage"
        ${pkgs.curl}/bin/curl -X POST $URL -d chat_id=$CHAT_ID -d text="$MESSAGE"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Notification Success" >> $log_dir/qb.log
    }
    echo "Torrent Name：$torrent_name" >> $log_dir/qb.log
    echo "Content Path：$content_dir" >> $log_dir/qb.log
    echo "File Number：$files_num" >> $log_dir/qb.log
    echo "Size：$torrent_size Bytes" >> $log_dir/qb.log
    echo "HASH: $file_hash" >> $log_dir/qb.log
    echo "Category: $torrent_category" >> $log_dir/qb.log
    check_category
    rclone_copy
    qb_del
    telegram
    echo -e "-------------------------------------------------------------\n" >> $log_dir/qb.log
  '';
in
{
  options = {
    services.qbittorrent-nox.enable = lib.mkEnableOption "qbittorrent-nox download service";
  };


  config = lib.mkIf cfg.enable {
    sops.secrets.tg-userid = { };
    sops.secrets.tg-notify-token = { };

    environment.systemPackages = with pkgs; [
      qbittorrent-nox
      rclone
      qbScript
    ];

    system.activationScripts.SyncQbDNS = lib.stringAfter [ "var" ] ''
      RED='\033[0;31m'
      NOCOLOR='\033[0m'

      if [ ! -f ${config.sops.secrets.cloudflare-dns-token.path} ]; then
        echo -e "$RED Sops-nix Known Limitations: https://github.com/Mic92/sops-nix#using-secrets-at-evaluation-time $NOCOLOR"
        echo -e "$RED Please switch system again to use sops secrets and sync DNS $NOCOLOR"
      else
        ${pkgs.cloudflare-dns-sync} qb.${config.networking.domain}
      fi
    '';


    # https://github.com/1sixth/flakes/blob/master/modules/qbittorrent-nox.nix
    # https://github.com/qbittorrent/qBittorrent/wiki/How-to-use-portable-mode

    systemd.services.qbittorrent-nox = {
      after = [ "local-fs.target" "network-online.target" "nss-lookup.target" ];
      description = "qBittorrent-nox service";
      serviceConfig = {
        ExecStart = "${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --profile=${qbConfigDir} --relative-fastresume";
        StateDirectory = "qbittorrent-nox";
      };
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
    };

    services.restic.backups."bt-backup" = {
      extraBackupArgs = [
        "--exclude=qBittorrent/downloads"
      ];
      passwordFile = config.sops.secrets.restic-password.path;
      rcloneConfigFile = config.sops.secrets.rclone-config.path;
      paths = [
        "${qbConfigDir}"
      ];
      repository = "rclone:r2:backup";
      timerConfig.OnCalendar = "01:00";
      pruneOpts = [ "--keep-last 2" ];
    };
  };
}
