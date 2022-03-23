FROM golang:1.16-alpine

WORKDIR /app
COPY *.go ./

RUN go mod init hello &&  \
    go mod tidy && \
    go test && \
    go build -o bin/hello

EXPOSE 8080

CMD [ "bin/hello" ]
