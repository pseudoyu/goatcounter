FROM alpine:latest

# Without this goatcounter won't start.
RUN apk --update --no-cache add tzdata
ENV TZ Asia/Shanghai

# Get binary pack based on architecture
ARG TARGETARCH

RUN if [ "$TARGETARCH" = "amd64" ]; then \
      wget https://github.com/arp242/goatcounter/releases/download/v2.5.0/goatcounter-v2.5.0-linux-amd64.gz && \
      gunzip goatcounter-v2.5.0-linux-amd64.gz && \
      mv goatcounter-v2.5.0-linux-amd64 goatcounter; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
      wget https://github.com/arp242/goatcounter/releases/download/v2.5.0/goatcounter-v2.5.0-linux-arm64.gz && \
      gunzip goatcounter-v2.5.0-linux-arm64.gz && \
      mv goatcounter-v2.5.0-linux-arm64 goatcounter; \
    elif [ "$TARGETARCH" = "arm" ]; then \
      wget https://github.com/arp242/goatcounter/releases/download/v2.5.0/goatcounter-v2.5.0-linux-arm.gz && \
      gunzip goatcounter-v2.5.0-linux-arm.gz && \
      mv goatcounter-v2.5.0-linux-arm goatcounter; \
    fi

RUN chmod a+x goatcounter

ENTRYPOINT ./goatcounter serve -listen "0.0.0.0:$PORT" -automigrate -tls none -db "$GOATCOUNTER_DB"
