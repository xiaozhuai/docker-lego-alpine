FROM golang:alpine AS builder

ENV GO111MODULE on
ENV CGO_ENABLED 0

RUN apk --no-cache add make git

RUN set -ex \
    && mkdir /code \
    && cd /code \
    && git clone https://github.com/go-acme/lego \
    && cd /code/lego \
    && make build

FROM alpine:latest

COPY --from=builder /code/lego/dist/lego /usr/bin/lego

RUN set -ex \
    && apk --no-cache add ca-certificates tzdata \
    && update-ca-certificates

ENTRYPOINT ["/usr/bin/lego"]
