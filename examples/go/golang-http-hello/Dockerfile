FROM golang:latest AS builder
ENV GO111MODULE=off
ENV TARGET=Kontain
ENV PORT=8080

ADD server.go /
WORKDIR /
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o server .

FROM scratch
COPY --from=builder server /server
CMD ["/server"]
