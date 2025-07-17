FROM golang:1.24-alpine AS builder

RUN apk update && apk upgrade && \
  apk --update add bash build-base git make

WORKDIR /app

COPY . .

RUN make build
RUN make build-migrate

# Distribution
FROM alpine:3.21.3

RUN apk update && apk upgrade && \
  apk --update --no-cache add tzdata && \
  mkdir /app 

WORKDIR /app 

EXPOSE 9090

COPY --from=builder /app/bin/engine /app/
COPY --from=builder /app/bin/migrate /app/

CMD ["/app/engine"]
