FROM debian:bullseye as builder

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y curl libreadline8 libreadline8 readline-common \
 && apt-get install -y build-essential libpng-dev libxml2-dev \
 && apt-get install -y libsdl1.2-dev libsdl1.2debian \
 && apt-get clean

WORKDIR /tmp
RUN curl -s -o joyce.tar.gz https://www.seasip.info/Unix/Joyce/joyce-2.4.0.tar.gz
RUN tar xzf joyce.tar.gz

RUN mkdir -p /opt/joyce \
 && cd /tmp/joyce* \
 && pwd \
 && ./configure --prefix=/opt/joyce \
 && make \
 && make check

RUN cd /tmp/joyce* \
 && make install
 
FROM alpine:3

COPY --from=builder /opt/joyce /opt/joyce

RUN apk update \
 && apk upgrade \
 && apk add sdl12-compat libxml2 \
 && apk add procps
RUN apk add x11vnc xvfb xfce4 xfce4-terminal

COPY /src/root/ /root/
COPY /src/etc/profile /etc/
COPY /src/usr/ /usr/

RUN mkdir -p /opt/floppies \
 && mkdir -p /opt/external-mount
COPY /src/opt/floppies/ /opt/floppies/

ENV SHELL=/bin/bash
ENV USER=root
ENV DISPLAY=:1

WORKDIR /root
RUN chmod 600 /root/.vnc/passwd

CMD [ "/usr/local/bin/startup" ]
