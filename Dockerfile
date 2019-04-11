# docker run -it --rm -v "`cygpath -w $(pwd)`":"/dmnt" registry.ft.fo/opencanary:latest bash
# docker run -it --rm --cap-add=NET_RAW registry.ft.fo/opencanary:latest
# docker run -it --rm --cap-add=NET_ADMIN registry.ft.fo/opencanary:latest
FROM alpine:latest

#libgcc (6.4.0-r9)
#libstdc++ (6.4.0-r9)
#gcc (6.4.0-r9)
#musl-dev (1.1.19-r10)
#libc-dev (0.7.1-r0)
#g++ (6.4.0-r9)

RUN apk update \
&& apk upgrade \
&& apk add bash
SHELL ["/bin/bash", "-c"]

RUN apk add bash python2 py2-pip py2-virtualenv sudo openssl libffi libpcap
RUN apk add --virtual .build-deps python2-dev libffi-dev openssl-dev libpcap-dev \
musl-dev libc-dev
RUN apk add libgcc libstdc++ iptables g++ gcc

RUN pip install --upgrade pip \
&& virtualenv env/ \
&& . env/bin/activate \
&& pip install --upgrade opencanary scapy pcapy rdpy service_identity \
&& opencanaryd --copyconfig

COPY "opencanary.conf" .
RUN apk del .build-deps

CMD . env/bin/activate && opencanaryd --dev
# cd ~ && opencanaryd --copyconfig && . env/bin/activate && opencanaryd --start