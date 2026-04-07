#!/usr/bin/env bash

set -o nounset # Treat unset variables as an error

rule=${1:-}
asn=${2:-}

if [[ -z "$rule" ]] || [[ -z "$asn" ]]; then
    echo "error: invalid arguments"
    echo "usage:"
    echo -e "\tnginx-acl-map.sh <rule> <asn>"
    echo -e "\tnginx-acl-map.sh 0 14061"
    echo -e "\tnginx-acl-map.sh 1 14061"
    exit 1
fi

curl -sS --fail "https://stat.ripe.net/data/as-overview/data.json?resource=AS{$asn}&sourceapp=nginx-acl-map" \
    | jq -r '"# AS" + .data.resource + ", " + .data.holder + ", " + .time' 
    
curl -sS --fail "https://stat.ripe.net/data/announced-prefixes/data.json?resource=AS${asn}&sourceapp=nginx-acl-map" \
  | jq -r '.data.prefixes[] | select(.prefix | contains(":") | not) | "\(.prefix)"' \
  | xargs -I% echo "% ${rule};"
