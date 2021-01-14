FROM alpine:3.12.3 as builder

ARG S3FS_VERSION=1.88

RUN apk --update add fuse alpine-sdk automake autoconf libxml2-dev fuse-dev curl-dev openssl-dev git
RUN git clone https://github.com/s3fs-fuse/s3fs-fuse.git && \
    cd s3fs-fuse && \
    git checkout tags/v${S3FS_VERSION} && \
    ./autogen.sh && \
    ./configure --prefix=/usr/local --with-openssl && \
    make && \
    make install

FROM alpine:3.12.3

RUN mkdir /mnt/s3

RUN apk --update add fuse libcrypto1.1 libcurl libgcc libstdc++ libxml2 musl openssl tini

ARG ENDPOINT
ARG URL

ENV BUCKET=teleport-bucket
ENV REGION=eu-west-1
ENV MOUNT_DIR=/mnt/s3


COPY --from=builder /usr/local/bin/s3fs /usr/local/bin/s3fs

ADD rootfs /

ENTRYPOINT ["/sbin/tini", "-g", "--"]
CMD ["/usr/bin/run.sh"]
