ARG KANIKO_RELEASE=debug

FROM gcr.io/kaniko-project/executor:${KANIKO_RELEASE} as kaniko
FROM alpine:3

ARG JQ_RELEASE="1.6"
ARG YQ_RELEASE="4.28.1"
ARG PUSHRM_RELEASE="1.9.0"

RUN set -eux && \
    apk add --update --no-cache \
    bash git grep tar xz gzip bzip2 curl coreutils openssl ca-certificates && \
    curl -sLo /usr/bin/jq \
      "https://github.com/stedolan/jq/releases/download/jq-$JQ_RELEASE/jq-linux64" && \
    curl -sLo /usr/bin/yq \
      "https://github.com/mikefarah/yq/releases/download/v$YQ_RELEASE/yq_linux_amd64" && \
    curl -sLo /usr/bin/pushrm \
      "https://github.com/christian-korneck/docker-pushrm/releases/download/v$PUSHRM_RELEASE/docker-pushrm_linux_amd64" && \
    chmod +x /usr/bin/jq /usr/bin/yq /usr/bin/pushrm

COPY --from=kaniko /kaniko /kaniko

ENV HOME /root
ENV USER root
ENV PATH=/kaniko:$PATH
ENV DOCKER_CONFIG='/kaniko/.docker'
ENV SSL_CERT_DIR=/kaniko/ssl/certs

WORKDIR /workspace

ENTRYPOINT ["/kaniko/executor"]