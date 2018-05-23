FROM alpine:edge

MAINTAINER Yosuke Matsusaka <yosuke.matsusaka@gmail.com>

RUN sed -i -e s/community/testing/g /etc/apk/repositories && \
    apk add --no-cache bash ipset iproute2 iprange curl unzip grep gawk lsof

RUN apk add --no-cache --virtual .firehol_builddep autoconf automake make git && \
    git clone --depth=1 https://github.com/firehol/firehol /tmp/firehol && \
    cd /tmp/firehol && \
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
