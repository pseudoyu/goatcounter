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

FROM gcr.io/distroless/base
COPY --from=build /app/goatcounter /goatcounter
EXPOSE 80 443
CMD ["/goatcounter", "serve"]
