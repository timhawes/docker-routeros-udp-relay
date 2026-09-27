ARG ALPINE=alpine:3.24.2
ARG TARGETARCH

FROM $ALPINE AS builder
WORKDIR /src
RUN apk add --no-cache musl-dev gcc git rust cargo

RUN \
  git clone --revision 0e38307668f6707fd5428c37e6b37b8d1b8944d9 https://github.com/marfillaster/udp-broadcast-relay-rs && \
  cd udp-broadcast-relay-rs && \
  cargo build --release && \
  cp target/release/udp-broadcast-relay-rs /udp-broadcast-relay-rs

FROM $ALPINE
RUN apk add --no-cache libgcc
COPY --from=builder /udp-broadcast-relay-rs /udp-broadcast-relay-rs
COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
