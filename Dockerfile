FROM golang:1.19.3 AS build

RUN adduser \
  --disabled-password \
  --gecos "" \
  --home "/nonexistent" \
  --shell "/sbin/nologin" \
  --no-create-home \
  --uid 65532 \
  runner

WORKDIR /app

COPY . .

RUN go mod tidy \
    && CGO_ENABLED=0 go build -ldflags="-s -w" -o /main .

FROM scratch

COPY --from=build /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /etc/passwd /etc/passwd
COPY --from=build /etc/group /etc/group
COPY --from=build /main .

USER runner:runner

CMD ["./main"]
