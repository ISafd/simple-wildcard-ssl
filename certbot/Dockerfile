FROM golang as builder

RUN go get github.com/koesie10/acme-dns-certbot-hook


FROM certbot/certbot

ADD ./entrypoint.sh /opt/certbot/

RUN mkdir -p /hooks/acme_dns/

COPY --from=builder /go/bin/acme-dns-certbot-hook /hooks/acme_dns/ 

ENTRYPOINT ["/opt/certbot/entrypoint.sh"]

