FROM golang:latest AS builder
ENV GO111MODULE=off
ENV TARGET=Kontain
ENV PORT=8080

ADD server.go /app/
WORKDIR /app
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /app/server .

FROM alpine
WORKDIR /app
COPY --from=builder /app/server /app/server
CMD ["/app/server"]
