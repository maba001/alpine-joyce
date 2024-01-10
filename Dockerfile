FROM alpine:3 as builder

RUN apk update \
 && apk upgrade \
 && apk add curl unzip m4 readline-dev libpng-dev \
 && apk add build-base libxml2-dev \
 && apk add sdl12-compat-dev

WORKDIR /tmp
RUN curl -s -o joyce.zip https://codeload.github.com/maba001/joyce-2.4.2/zip/refs/heads/main
RUN unzip joyce.zip

RUN mkdir -p /opt/joyce \
 && cd /tmp/joyce* \
 && pwd \
 && chmod +x configure config/install-sh \
 && ./configure --prefix=/opt/joyce || true \
 && cat config.log \
 && make \
 && make check

RUN cd /tmp/joyce* \
 && make install
RUN mkdir -p /opt/joyce \
 && touch /opt/joyce/dummy
 
FROM alpine:3

COPY --from=builder /opt/joyce /opt/joyce

RUN apk update \
 && apk upgrade \
 && apk add sdl12-compat libxml2 \
 && apk add bash procps \
 && apk add alpine-conf
RUN apk add x11vnc 
RUN apk add xvfb xfce4 kbd lxdm xfce4-terminal mesa-dri-gallium

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

# CMD [ "/usr/local/bin/startup" ]
