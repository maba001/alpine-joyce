FROM alpine:3 as builder

RUN apk update \
 && apk upgrade \
 && apk add curl readline-dev libpng-dev \
 && apk add build-base libxml2-dev \
 && apk add sdl12-compat-dev

WORKDIR /tmp
RUN curl -s -o joyce.tar.gz https://www.seasip.info/Unix/Joyce/joyce-2.4.0.tar.gz
RUN tar xzf joyce.tar.gz

RUN mkdir -p /opt/joyce \
 && cd /tmp/joyce* \
 && pwd \
 && ./configure --prefix=/opt/joyce \
 && make || true \
 && make check || true

# RUN cd /tmp/joyce* \
# && make install
RUN mkdir -p /opt/joyce \
 && touch /opt/joyce/dummy

FROM alpine:3

COPY --from=builder /opt/joyce /opt/joyce

RUN apk update \
 && apk upgrade \
 && apk add sdl12-compat libxml2 \
 && apk add procps
RUN apk add x11vnc xterm xclock \
 && apk add xvfb xfce4 faenza-icon-theme

COPY /src/root/ /root/
COPY /src/etc/profile /etc/
COPY /src/etc/tigervnc /etc/tigervnc/
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
