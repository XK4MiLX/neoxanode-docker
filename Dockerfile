
ARG UBUNTUVER=20.04
FROM ubuntu:${UBUNTUVER}

RUN mkdir -p /root/.firo
RUN apt-get update && apt-get install -y  tar wget curl pwgen
RUN wget https://downloads.sourceforge.net/project/firoorg/firo-0.14.9.0-linux64.tar.gz -P /tmp
RUN tar xzvf /tmp/firo-0.14.9.0-linux64.tar.gz -C /tmp \
&& cp /tmp/firo-0.14.9/bin/* /usr/local/bin
COPY node_initialize.sh /node_initialize.sh
VOLUME /root/.firo
RUN chmod 755 node_initialize.sh
EXPOSE 8168
CMD ./node_initialize.sh