FROM golang:1.21-bullseye AS build

# Install build dependencies for CGO support
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    gcc \
    libc6-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

# Enable CGO support
ENV CGO_ENABLED=1

RUN go build -ldflags="-X zgo.at/goatcounter/v2.Version=$(git log -n1 --format='%h_%cI')" ./cmd/goatcounter

FROM debian:bullseye-slim
COPY --from=build /app/goatcounter /goatcounter
ENTRYPOINT ./goatcounter serve -listen "0.0.0.0:$PORT" -automigrate -tls none -db "$GOATCOUNTER_DB"
