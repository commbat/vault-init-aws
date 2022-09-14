FROM golang:1.19.1-alpine AS builder
WORKDIR /go/src/app
COPY main.go go.mod go.sum ./
RUN CGO_ENABLED=0 go build -ldflags="-w -s" -o vault-init -v .

FROM scratch
COPY --from=builder /go/src/app/vault-init .
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["/vault-init"]
