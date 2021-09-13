# syntax=docker/dockerfile:1

# This is optional but it instructs the Docker builder what syntax to use when parsing the Dockerfile. This was used as it always points to the latest release of the version 1 syntax.

# Alpine is chosen for its small footprint
# compared to Ubuntu
# As we are using Go I used the official Go image that already included all the tools and packages to compile and run a Go application.
FROM golang:1.16-alpine

# Assign environment variables
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64 

# Create destination directory saves typing full file paths and can use relative paths
WORKDIR /app

# Download necessary Go modules
COPY app/go.mod ./
RUN go mod download

# Copy over source code
COPY app/main.go ./

RUN go build -o /opg-dockerise-go

# Specify the port where Docker will get all its information from
EXPOSE 8080

# CMD  tells Docker what command to execute when the image is used to start a container
CMD ["/opg-dockerise-go"]