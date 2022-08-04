{ pkgs, config, ... }:
let
  # arg1 = domain
  cloudflare-dns-sync = ''
    GREEN='\033[0;32m' 
    YELLOW='\033[0;33m'
    RED='\033[0;31m'
    NOCOLOR='\033[0m'

    if [ ! -f ${config.sops.secrets.cloudflare-dns-token.path} ]; then
      echo -e "$RED Sops-nix Known Limitations: https://github.com/Mic92/sops-nix#using-secrets-at-evaluation-time $NOCOLOR"
      echo -e "$RED Please rebuild system again to use sops secrets $NOCOLOR"
      exit 1;
    fi

    domain=$1

    token=$(cat ${config.sops.secrets.cloudflare-dns-token.path})
    zoneid=$(cat ${config.sops.secrets.cloudflare-zone-id.path})

    result=$(${pkgs.curl}/bin/curl --silent "https://api.cloudflare.com/client/v4/zones/$zoneid/dns_records?name=$domain" \
         -H "Content-Type: application/json" \
         -H "Authorization: Bearer $token" | ${pkgs.jq}/bin/jq ".result[0]")

    localIP=$(${pkgs.curl}/bin/curl --silent -4 ip.sb)

    if [ "$result" = "null" ]; then
      echo -e "$YELLOW $domain DNS Not Registered, Create DNS Record Now $NOCOLOR"
      requestData=$(${pkgs.jq}/bin/jq --null-input --arg domain $domain --arg content $localIP '{"type":"A","name": $domain,"content": $content,"ttl":1,"proxied":false}')
      ${pkgs.curl}/bin/curl --silent -X POST "https://api.cloudflare.com/client/v4/zones/$zoneid/dns_records" \
         -H "Content-Type: application/json" \
         -H "Authorization: Bearer $token" \
         --data "$requestData"
    else
      echo -e "$GREEN $domain DNS Registered $NOCOLOR"
      dnsID=$(echo $result | ${pkgs.jq}/bin/jq .id | tr -d '"')
      recordIP=$(echo $result | ${pkgs.jq}/bin/jq .content | tr -d '"')
      if [ $localIP != $recordIP ]; then
        #echo "IP Not Match, Update DNS Record"
        echo -e "$YELLOW IP Not Match, Update DNS Record$NOCOLOR"
        requestData=$(${pkgs.jq}/bin/jq --null-input --arg domain $domain --arg content $localIP '{"type":"A","name": $domain,"content": $content,"ttl":1,"proxied":false}')
        ${pkgs.curl}/bin/curl --silent -X PUT "https://api.cloudflare.com/client/v4/zones/$zoneid/dns_records/$dnsID" \
         -H "Content-Type: application/json" \
         -H "Authorization: Bearer $token" \
         --data "$requestData"
      fi
    fi
  '';

in
{

  sops.secrets.cloudflare-dns-token = { };
  sops.secrets.cloudflare-zone-id = { };


  nixpkgs.overlays = [
    (final: prev: {
      cloudflare-dns-sync = prev.writeShellScript "cloudflare-dns-sync" cloudflare-dns-sync;
    })
  ];

}
