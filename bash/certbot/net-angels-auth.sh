#!/bin/bash
# Основные параметры
KEY="<api_key>"
ID="<record_id>"
NAME="_acme-challenge.<domain>"
#CERTBOT_VALIDATION="test"

TOKEN=$(curl --location 'https://panel.netangels.ru/api/gateway/token/' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'api_key='$KEY | jq -r '.token')

curl --location 'https://api-ms.netangels.ru/api/v1/dns/records/'$ID'/' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer '$TOKEN \
--data '{
    "name": "'$NAME'",
    "ttl": 600,
    "value": "'$CERTBOT_VALIDATION'"
}'

echo -e "Record updated"
# Ожидание обновления
sleep 300