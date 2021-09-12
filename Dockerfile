# syntax=docker/dockerfile:1

# Alpine is chosen for its small footprint
# compared to Ubuntu
FROM golang:1.16-alpine

ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64 \

WORKDIR /app

# Download necessary Go modules
COPY app/go.mod ./
RUN go mod download

COPY app/main.go ./

RUN go build -o /opg-dockerise-go

EXPOSE 8080

CMD ["/opg-dockerise-go"]