FROM golang:1.16-alpine
RUN mkdir /app
WORKDIR /app
COPY *.go /app/

RUN go mod init test &&  \
    go mod tidy && \
    go test && \
    go build -o main .


ENTRYPOINT [ "/app/main" ]
