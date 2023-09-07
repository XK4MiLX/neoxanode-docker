
ARG UBUNTUVER=20.04
FROM ubuntu:${UBUNTUVER}
LABEL com.centurylinklabs.watchtower.enable="true"

RUN mkdir -p /root/.neoxa
RUN apt-get update && apt-get install -y  tar wget curl pwgen jq
RUN wget https://github.com/NeoxaChain/Neoxa/releases/download/v5.1.1.4/neoxad-5.1.1.4-linux64.tar -P /tmp
RUN tar xzvf /tmp/neoxad-5.1.1.4-linux64.tar.gz -C /tmp \
&& cp /tmp/firo-c7e3ef0e6af6/bin/* /usr/local/bin
COPY node_initialize.sh /node_initialize.sh
COPY check-health.sh /check-health.sh
VOLUME /root/.neoxa
RUN chmod 755 node_initialize.sh check-health.sh
EXPOSE 8788
HEALTHCHECK --start-period=5m --interval=2m --retries=5 --timeout=15s CMD ./check-health.sh
CMD ./node_initialize.sh
