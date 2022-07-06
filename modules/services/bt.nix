{ pkgs
, lib
, config
, ...
}:
let
  cfg = config.services.bt;
  domain = "${config.networking.hostName}.mlyxshi.com";
  #  Run external program on torrent completion
  # /run/current-system/sw/bin/qbScript "%N" "%F" "%C" "%Z" "%I" "%L"
  qbScript = pkgs.writeShellScriptBin "qbScript" ''
    torrent_name=''$1
    content_dir=''$2
    files_num=''$3
    torrent_size=''$4
    file_hash=''$5
    torrent_category=''$6

    qb_web_url="localhost:8080"
    rclone_dest="googleshare:Download"
    log_dir="/var/lib/qbittorrent-nox/qBLog"
    rclone_parallel="32"
    # For leech_category, after download, upload to googledrive and delete immediately(important resource, Public BT)
    leech_category="leech"
    # For upload_category, after download, upload to googledrive but do not auto delete(important resource, PT share ratio requirement)
    upload_category="upload"
    # For Anything else, after download, do not upload and keep seeding(unimportant resource, only for improving PT statistics)
    # https://github.com/jerrymakesjelly/autoremove-torrents

    if [ ! -d ''${log_dir} ]
    then
        mkdir -p ''${log_dir}
    fi


    function check_category(){
        if [ "''${torrent_category}" == ''${leech_category} ]
        then
            echo "[''$(date '+%Y-%m-%d %H:%M:%S')] Detect Leech Category, Continue" >> ''${log_dir}/qb.log 
        elif [ "''${torrent_category}" == ''${upload_category} ]
        then 
            echo "[''$(date '+%Y-%m-%d %H:%M:%S')] Detect Upload Category, Continue" >> ''${log_dir}/qb.log 
        else
            echo "[''$(date '+%Y-%m-%d %H:%M:%S')] Not Leech or Upload Category, EXIT" >> ''${log_dir}/qb.log
            echo -e "-------------------------------------------------------------\n" >> ''${log_dir}/qb.log
            exit 0       
        fi
    }

    function rclone_copy(){
        if [ -f "''${content_dir}" ]
        then
            ${pkgs.rclone}/bin/rclone --config /var/lib/qbittorrent-nox/rclone/rclone.conf -v copy --log-file  ''${log_dir}/rclone.log "''${content_dir}" ''${rclone_dest}
        elif [ -d "''${content_dir}" ]
        then
            ${pkgs.rclone}/bin/rclone --config /var/lib/qbittorrent-nox/rclone/rclone.conf -v copy --transfers ''${rclone_parallel} --log-file ''${log_dir}/rclone.log "''${content_dir}" ''${rclone_dest}/"''${torrent_name}"
        fi

        echo -e "-------------------------------------------------------------\n" >> ''${log_dir}/rclone.log
    }

    function qb_del(){
        if [ ''${torrent_category} == ''${leech_category} ]
        then
            ${pkgs.curl}/bin/curl -X POST -d "hashes=''${file_hash}&deleteFiles=true" "''${qb_web_url}/api/v2/torrents/delete" 
            echo "[''$(date '+%Y-%m-%d %H:%M:%S')] Auto-delete Success" >> ''${log_dir}/qb.log
        elif [ ''${torrent_category} == ''${upload_category} ]
        then
            echo "[''$(date '+%Y-%m-%d %H:%M:%S')] Upload Category: Do Not Auto-delete" >> ''${log_dir}/qb.log
        fi
    }

    function telegram(){
        TOKEN=''$(cat ${config.sops.secrets.tg-token.path})
        CHAT_ID=''$(cat ${config.sops.secrets.tg-chatid.path})
        MESSAGE="''${torrent_name} GoogleDrive Upload Success"
        URL="https://api.telegram.org/bot$TOKEN/sendMessage"
        ${pkgs.curl}/bin/curl -X POST ''${URL} -d chat_id=''${CHAT_ID} -d text="$MESSAGE"
        echo "[''$(date '+%Y-%m-%d %H:%M:%S')] Notification Success" >> ''${log_dir}/qb.log
    }


    echo "Torrent Name：${torrent_name}" >> ''${log_dir}/qb.log
    echo "Content Path：''${content_dir}" >> ''${log_dir}/qb.log
    echo "File Number：''${files_num}" >> ''${log_dir}/qb.log
    echo "Size：''${torrent_size} Bytes" >> ''${log_dir}/qb.log
    echo "HASH: ''${file_hash}" >> ''${log_dir}/qb.log
    echo "Category: ''${torrent_category}" >> ''${log_dir}/qb.log

    check_category
    rclone_copy
    qb_del
    telegram

    echo -e "-------------------------------------------------------------\n" >> ''${log_dir}/qb.log

  '';



in
{
  options = {
    services.bt.enable = lib.mkEnableOption "bt download service";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      qbittorrent-nox
      rclone 
      qbScript
    ];


    # https://github.com/1sixth/flakes/blob/master/modules/qbittorrent-nox.nix
    # https://github.com/qbittorrent/qBittorrent/wiki/How-to-use-portable-mode

    systemd.services.qbittorrent-nox = {
      after = [ "local-fs.target" "network-online.target" "nss-lookup.target" ];
      description = "qBittorrent-nox service";
      serviceConfig = {
        ExecStart = "${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --profile=/var/lib/qbittorrent-nox --relative-fastresume";
        StateDirectory = "qbittorrent-nox";
      };
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
    };

    sops.secrets.tg-chatid = { };
    sops.secrets.tg-token = { };

  };
}





