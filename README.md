# Simple setup for issuing and autorenewing letsencrypt ssl certs

Made upon [joohoi/acme-dns](https://github.com/joohoi/acme-dns) and [koesie10/acme-dns-certbot-hook](https://github.com/koesie10/acme-dns-certbot-hook).

## Usage

Run `./up.sh your.domain.com`, add provided DNS-record and press enter.

It will run one container for cerbot and one for acme-dns. Your certs will be in `letsencrypt_data` volume under `live/your.domain.com/` path.

