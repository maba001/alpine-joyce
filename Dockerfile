FROM alpine:3 as builder

RUN apk update \
 && apk upgrade -y \
 && apk install -y curl libreadline8 libreadline8 readline-common \
 && apk install -y build-essential libpng-dev libxml2-dev \
 && apk install -y libsdl1.2-dev libsdl1.2debian \
 && apk clean

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
 && apk upgrade -y \
 && apk install -y telnet \
 && apk install -y libsdl1.2debian libxml2 \
 && apk install -y tigervnc-standalone-server xfonts-base xterm x11-apps \
 && apk install -y procps dbus-x11 \
 && apk clean \
 && rm -rf /var/lib/apt/lists/*


COPY /src/root/ /root/
COPY /src/etc/profile /etc/
COPY /src/etc/tigervnc /etc/tigervnc/
COPY /src/etc/bash.bashrc /etc/
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
