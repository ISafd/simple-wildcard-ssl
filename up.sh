#!/bin/bash

domain=$1

# make acme_dns config
sed "s/{{domain}}/$domain/g" config/acme_dns/config.cfg.template > config/acme_dns/config.cfg

# run containers
docker-compose up -d

# sleep a little bit 
#sleep 4s

# register in acme_dns
acmedns_container=$(docker-compose ps | grep acmedns | cut -f 1 -d ' ')
acmedns_container_ip=$(docker container inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $acmedns_container)
registration_info=$(curl -X POST $acmedns_container_ip/register)
trimmed_registration_info=$(echo $registration_info | tr -d '{' | tr -d '}')

# make hook config
sed "s/{{domain}}/$domain/g; s/{{options}}/${trimmed_registration_info}/g" config/acme_dns_hook/config.json.template > config/acme_dns_hook/config.json

# show dns-records to add
fulldomain=$(echo $registration_info | tr -s ',' '\n' | grep fulldomain | cut -f 2 -d : | tr -d '"')
cat <<EOF
Add these records:

CNAME  _acme-challenge  $fulldomain
CNAME  auth.$domain     <your ip>
NS     auth             auth.vomidug.xyz

EOF
read i

# generate certs
certbot_container=$(docker-compose ps | grep certbot | cut -f 1 -d ' ')
docker exec $certbot_container sh generate.sh -d $domain,*.$domain

