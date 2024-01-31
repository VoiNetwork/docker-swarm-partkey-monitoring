FROM alpine:3.19.1

# Install required packages
RUN apk add --no-cache \
    bash \
    curl \
    jq \
    bc \
    ca-certificates \
    openssl \
    tzdata

COPY ./scripts /scripts

CMD ["/scripts/find-expiring-partkeys.sh"]
