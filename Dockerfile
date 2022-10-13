FROM gcr.io/kaniko-project/executor:debug as kaniko
FROM alpine:3

RUN apk update && \
  apk upgrade && \
  apk add --update --no-cache \
    bash git grep tar xz gzip bzip2 curl coreutils openssl ca-certificates jq yq

COPY --from=kaniko /kaniko /kaniko

ENV HOME /root
ENV USER root
ENV PATH=/kaniko:$PATH
ENV DOCKER_CONFIG='/kaniko/.docker'
ENV SSL_CERT_DIR=/kaniko/ssl/certs

WORKDIR /workspace

ENTRYPOINT ["/kaniko/executor"]