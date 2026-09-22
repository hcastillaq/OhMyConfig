FROM golang:1.27-alpine AS builder

WORKDIR /app

ENV GOOS=darwin
ENV GOARCH=arm64
ENV CGO_ENABLED=0

COPY go.mod ./
RUN go mod download

COPY cmd ./cmd
COPY internal ./internal

RUN mkdir -p /out
RUN go build -o /out/omc ./cmd/omc

FROM scratch AS export

COPY --from=builder /out/omc /omc-darwin-arm64
