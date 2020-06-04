#!/bin/sh

certbot renew --manual \
	--manual-auth-hook '/hooks/acme_dns/acme-dns-certbot-hook -config /hooks/acme_dns/config/config.json'\
	--preferred-challenges dns \
	--agree-tos \
	$@

