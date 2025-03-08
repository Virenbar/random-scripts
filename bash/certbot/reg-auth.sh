#!/bin/bash
# Основные параметры
USER="<username>"
PASS="<password>"
DOMAIN="<domain>"
SUBDOMAIN="_acme-challenge"
#CERTBOT_VALIDATION="test"

# Параметры для удаления текущих записей
DELETE=$(jq -n --arg USER $USER \
--arg PASS $PASS \
--arg DOMAIN $DOMAIN \
--arg SUBDOMAIN $SUBDOMAIN '{
    "username": $USER,
    "password": $PASS,
    "domains": [{"dname": $DOMAIN}],
    "subdomain": $SUBDOMAIN,
    "record_type": "TXT",
    "output_content_type": "plain"
}')
TXT_DELETE="input_format=json&input_data=$DELETE"

# Параметры для добавления записи
ADD=$(jq -n --arg USER $USER \
--arg PASS $PASS \
--arg DOMAIN $DOMAIN \
--arg SUBDOMAIN $SUBDOMAIN \
--arg TEXT $CERTBOT_VALIDATION '{
    "username": $USER,
    "password": $PASS,
    "domains": [{"dname": $DOMAIN}],
    "subdomain": $SUBDOMAIN,
    "text": $TEXT,
    "output_content_type": "plain"
}')
TXT_ADD="input_format=json&input_data=$ADD"

#echo -e "DELETE: $TXT_DELETE\n"
#echo -e "ADD: $TXT_ADD\n"

curl -X GET -d "$TXT_DELETE" "https://api.reg.ru/api/regru2/zone/remove_record"
curl -X GET -d "$TXT_ADD" "https://api.reg.ru/api/regru2/zone/add_txt"
#
echo -e "Record added"
# Sleep
sleep 300