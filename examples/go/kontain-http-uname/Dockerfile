# Use the offical Golang image to create a build artifact.
# This is based on Debian and sets the GOPATH to /go.
# https://hub.docker.com/_/golang
FROM registry.cn-hangzhou.aliyuncs.com/knative-sample/golang:1.12 as builder

# Copy local code to the container image.
WORKDIR /go/src/github.com/knative-sample/server
COPY . .

# Build the command inside the container.
# (You may fetch or manage dependencies here,
# either manually or with a tool like "godep".)
RUN CGO_ENABLED=0 GOOS=linux go build -v -o server

# Use a Docker multi-stage build to create a lean production image.
# https://docs.docker.com/develop/develop-images/multistage-build/#use-multi-stage-builds
FROM registry.cn-hangzhou.aliyuncs.com/knative-sample/alpine-sh:3.9
# RUN apk add --no-cache ca-certificates

# Copy the binary to the production image from the builder stage.
COPY --from=builder /go/src/github.com/knative-sample/server/server /server

# Run the web service on container startup.
CMD ["/server"]
