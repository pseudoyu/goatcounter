FROM alpine:latest

# Without this goatcounter won't start.
RUN apk --update --no-cache add tzdata
ENV TZ Asia/Shanghai

# Get binary pack
RUN wget https://github.com/arp242/goatcounter/releases/download/v2.5.0/goatcounter-v2.5.0-linux-amd64.gz
RUN gunzip goatcounter-v2.5.0-linux-amd64.gz
RUN mv goatcounter-v2.5.0-linux-amd64 goatcounter
RUN chmod a+x goatcounter

ENTRYPOINT ./goatcounter serve -listen "0.0.0.0:$PORT" -automigrate -tls none -db "$GOATCOUNTER_DB"
