{ pkgs, config, ... }: {

  sops.secrets.cloudflare-dns-token = { };
  sops.secrets.cloudflare-zone-id = { };
  # arg1 = domain
  cloudflare-dns-sync = pkgs.writeShellScript "cloudflare-dns-sync" ''
    domain=$1

    token=$(cat ${config.sops.secrets.cloudflare-dns-token.path})
    zoneid=$(cat ${config.sops.secrets.cloudflare-zone-id.path})

    result=$(${pkgs.curl}/bin/curl --silent "https://api.cloudflare.com/client/v4/zones/$zoneid/dns_records?name=$domain" \
         -H 'Content-Type: application/json' \
         -H 'Authorization: Bearer $token' | ${pkgs.jq}/bin/jq ".result[0]")

    localIP=$(${pkgs.curl}/bin/curl --silent -4 ip.sb)

    if [ "$result" = "null" ]; then
      echo "not found, create dns record"
      requestData=$(${pkgs.jq}/bin/jq --null-input --arg domain $domain --arg content $localIP '{"type":"A","name": $domain,"content": $content,"ttl":1,"proxied":false}')
      ${pkgs.curl}/bin/curl --silent -X POST "https://api.cloudflare.com/client/v4/zones/$zoneid/dns_records" \
         -H 'Content-Type: application/json' \
         -H 'Authorization: Bearer $token' \
         --data "$requestData"
    else
      echo "found"
      dnsID=$(echo $result | ${pkgs.jq}/bin/jq .id | tr -d '"')
      recordIP=$(echo $result | ${pkgs.jq}/bin/jq .content | tr -d '"')
      if [ $localIP != $recordIP ]; then
        echo "update dns record"
        requestData=$(${pkgs.jq}/bin/jq --null-input --arg domain $domain --arg content $localIP '{"type":"A","name": $domain,"content": $content,"ttl":1,"proxied":false}')
        ${pkgs.curl}/bin/curl --silent -X PUT "https://api.cloudflare.com/client/v4/zones/$zoneid/dns_records/$dnsID" \
         -H 'Content-Type: application/json' \
         -H 'Authorization: Bearer $token' \
         --data "$requestData"
      fi
    fi
  '';


  environment.systemPackages = [
    pkgs.cloudflare-dns-sync
  ];

}
