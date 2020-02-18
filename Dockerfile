FROM alpine:latest

RUN apk update \
&& apk upgrade \
&& apk add bash
SHELL ["/bin/bash", "-c"]

RUN apk add bash python2 py2-pip sudo openssl libffi libpcap
RUN apk add --virtual .build-deps python2-dev libffi-dev openssl-dev libpcap-dev \
musl-dev libc-dev
RUN apk add libgcc libstdc++ iptables g++ gcc

RUN pip install virtualenv

RUN pip install --upgrade pip \
&& virtualenv env/ \
&& . env/bin/activate \
&& pip install --upgrade opencanary scapy pcapy rdpy service_identity \
&& opencanaryd --copyconfig

COPY "opencanary.conf" .

RUN apk del .build-deps

CMD . env/bin/activate && opencanaryd --dev