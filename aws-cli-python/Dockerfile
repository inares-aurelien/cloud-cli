# Based on https://github.com/cgswong/docker-aws/blob/aws/Dockerfile
FROM python:3.6-alpine3.6

MAINTAINER Aurelien DEVAUX <aurelien.devaux@inares.org>

# http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="AWS-CLI (python)" \
      org.label-schema.description="Docker image for AWS CLI on Python" \
      org.label-schema.url="https://github.com/inares/" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/inares/" \
      org.label-schema.vendor="Aurélien DEVAUX" \
      org.label-schema.version="1.0" \
      org.label-schema.schema-version="1.0"


RUN echo -e "\n\n\n***** Upgrading *****\n"                                                                 && \
    apk --update --no-progress upgrade                                                                      && \
    \
    echo -e "\n\n\n***** Adding packages *****\n"                                                           && \
    apk --no-progress add openssl ca-certificates git nano bash bash-completion curl jq groff               && \
    update-ca-certificates                                                                                  && \
    \
    echo -e "\n\n\n***** Installing AWS-CLI *****\n"                                                        && \
    pip install awscli                                                                                      && \
    mkdir /root/.aws                                                                                        && \
    \
    echo -e "\n\n\n***** Azure-CLI version *****"                                                           && \
    aws --version                                                                                           && \
    \
    echo -e "\n\n\n***** Clean the packages *****\n"                                                        && \
    rm -rf /var/cache/apk/* /tmp/* /var/tmp/* /root/.cache                                                  && \
    \
    echo -e "\n\n\n*********************************************\n\n"


# Customization
COPY common-files/  /
COPY aws-cli-python/files/  /
RUN echo "Europe/Paris" > /etc/timezone                     ; \
    chmod 640 /root/.bashrc                                 ; \
    chmod 644 /etc/localtime

ENV ENV /etc/profile
WORKDIR /root/
VOLUME ["/root/.aws/"]

CMD ["bash"]
