FROM alpine:latest

RUN sed -i 's/https/http/' /etc/apk/repositories

RUN apk add --update --no-cache ca-certificates tzdata

# Install wine and wget
RUN apk update \
    && apk add --update --no-cache wine \
    && apk add --update --no-cache winetricks --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/ \
    && apk add --update --no-cache wget \
    && apk add --update --no-cache unzip \
    && apk add --update --no-cache bash \
    && apk add --update --no-cache grep \
    && apk add --update --no-cache gnupg

RUN winetricks -q dotnet48

ADD https://api.github.com/repos/pwntester/ysoserial.net/releases/latest latest_release.json
RUN wget $(wget -q -O - https://api.github.com/repos/pwntester/ysoserial.net/releases/latest | grep -oP '(?<="browser_download_url": ").*ysoserial-.*\.zip') -O ysoserial.zip \
    && unzip ysoserial.zip -d ysoserial

RUN echo 'alias ysoserial="WINEDEBUG=-all wine /ysoserial/Release/ysoserial.exe"' >> ~/.bashrc

SHELL ["/bin/bash", "-c"]