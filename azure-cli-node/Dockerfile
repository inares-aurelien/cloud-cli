# Based on https://hub.docker.com/r/microsoft/azure-cli/
FROM mhart/alpine-node:latest

MAINTAINER Aurelien DEVAUX <aurelien.devaux@inares.org>

# http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Azure-CLI NodeJS" \
      org.label-schema.description="Docker image for Azure CLI on NodeJS" \
      org.label-schema.url="https://github.com/inares/azure-cli/nodeJS" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/inares/azure-cli/nodeJS" \
      org.label-schema.vendor="Aurélien DEVAUX" \
      org.label-schema.version="1.0" \
      org.label-schema.schema-version="1.0"


RUN echo -e "\n\n\n***** Upgrading *****\n"                                                                 && \
    apk --update --no-progress upgrade                                                                      && \
    \
    echo -e "\n\n\n***** Adding packages *****\n"                                                           && \
    apk --no-progress add openssl ca-certificates git nano python make gcc g++ bash bash-completion jq      && \
    update-ca-certificates                                                                                  && \
    \
    echo -e "\n\n\n***** Installing Azure-CLI *****\n"                                                      && \
    npm install --unsafe-perm --global --production --silent azure-cli                                      && \
    azure telemetry --disable > /dev/null                                                                   && \
    azure config mode arm  > /dev/null                                                                      && \
    azure --completion > /root/azure.completion.sh                                                          && \
    \
    echo -e "\n\n\n***** Azure-CLI version *****"                                                           && \
    azure --version                                                                                         && \
    \
    echo -e "\n\n\n***** Clean the packages *****\n"                                                        && \
    apk del --purge --no-progress python make gcc g++                                                       && \
    rm -rf /var/cache/apk/* /tmp/* /var/tmp/*                                                               && \
    \
    echo -e "\n\n\n*********************************************\n\n"


# Customization
COPY common-files/  /
RUN echo "Europe/Paris" > /etc/timezone                     ; \
    chmod 640 /root/.bashrc                                 ; \
    chmod 644 /etc/localtime

ENV ENV /etc/profile
WORKDIR /root/

CMD ["bash"]
