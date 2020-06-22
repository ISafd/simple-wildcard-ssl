#!/bin/sh

SLEEP_INTERVAL=${SLEEP_INTERVAL:-12h}

echo "Sleep interval $SLEEP_INTERVAL"

while true
do
	echo "Starting certbot"
	test -e /etc/letsencrypt/dhparam.pem || ( echo "Generate stronger DHE parameter" ; openssl dhparam -out /etc/letsencrypt/dhparam.pem 4096)
	certbot renew --manual \
		--manual-auth-hook '/hooks/acme_dns/acme-dns-certbot-hook -config /hooks/acme_dns/config/config.json'\
		--preferred-challenges dns \
		--agree-tos
	echo
	echo "Sleeping ${SLEEP_INTERVAL} until next renew attempt..."
	sleep ${SLEEP_INTERVAL}
done
