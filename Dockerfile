FROM alpine:edge

MAINTAINER Yosuke Matsusaka <yosuke.matsusaka@gmail.com>

RUN sed -i -e s/community/testing/g /etc/apk/repositories && \
    apk add --no-cache bash ipset iproute2 iprange curl unzip grep gawk lsof

ENV FIREHOL_VERSION 3.1.5

RUN apk add --no-cache --virtual .firehol_builddep autoconf automake make && \
    curl -L https://github.com/firehol/firehol/releases/download/v$FIREHOL_VERSION/firehol-$FIREHOL_VERSION.tar.gz | tar zvx -C /tmp && \
    cd /tmp/firehol-$FIREHOL_VERSION && \
    ./autogen.sh && \
    ./configure --prefix= --disable-doc --disable-man && \
    make && \
    make install && \
    cp contrib/ipset-apply.sh /bin/ipset-apply && \
    cd && \
    rm -rf /tmp/firehol-$FIREHOL_VERSION && \
    apk del .firehol_builddep

VOLUME /etc/firehol/ipsets

ENTRYPOINT ["/sbin/update-ipsets"]
