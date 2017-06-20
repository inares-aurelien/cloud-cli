# Based on https://hub.docker.com/r/azuresdk/azure-cli-python/
FROM python:3.6-alpine3.6

MAINTAINER Aurelien DEVAUX <aurelien.devaux@inares.org>

# http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Azure-CLI Python" \
      org.label-schema.description="Docker image for Azure CLI on Python" \
      org.label-schema.url="https://github.com/inares/azure-cli/python" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/inares/azure-cli/python" \
      org.label-schema.vendor="Aurélien DEVAUX" \
      org.label-schema.version="1.0" \
      org.label-schema.schema-version="1.0"

      
# pip wheel - required for CLI packaging
# bash gcc openssl-dev libffi-dev musl-dev - dependencies required for CLI
# openssh-client - included for ssh-keygen
# 1. Build packages and store in tmp dir
# 2. Install the cli and the other command modules that weren't included
# 3. Temporary fix - install azure-nspkg to remove import of pkg_resources in azure/__init__.py (to improve performance)
RUN echo -e "\n\n\n***** Upgrading *****\n"                                                                 && \
    apk --update --no-progress upgrade                                                                      && \
    \
    echo -e "\n\n\n***** Adding packages *****\n"                                                           && \
    apk --no-progress add openssl ca-certificates git nano bash bash-completion curl jq openssh-client      && \
    apk --no-progress add --virtual=build gcc make libffi-dev musl-dev openssl-dev                          && \
    update-ca-certificates                                                                                  && \
    \
    echo -e "\n\n\n***** Clone Azure-CLI repo *****\n"                                                      && \
    git clone https://github.com/azure/azure-cli /azure-cli --depth=1                                       && \
    cd /azure-cli/                                                                                          && \
    \
    echo -e "\n\n\n***** Build packages *****\n"                                                            && \
    /bin/bash -c 'TMP_PKG_DIR=$(mktemp -d); \
    for d in src/azure-cli src/azure-cli-core src/azure-cli-nspkg src/azure-cli-command_modules-nspkg src/command_modules/azure-cli-*/; \
    do cd $d; python setup.py bdist_wheel -d $TMP_PKG_DIR > /dev/null; cd -; \
    done; \
    MODULE_NAMES=""; \
    for f in $TMP_PKG_DIR/*; \
    do MODULE_NAMES="$MODULE_NAMES $f" > /dev/null; \
    done; \
    echo -e "\n\n\n***** Install the CLI *****\n"; \
    pip install --quiet $MODULE_NAMES; \
    pip install --quiet --force-reinstall --upgrade azure-nspkg azure-mgmt-nspkg;'                          && \
    \
    echo -e "\n\n\n***** Clean the packages *****\n"                                                        && \
    cd /                                                                                                    && \
    apk del --purge --no-progress build                                                                     && \
    rm -rf /var/cache/apk/* /tmp/* /var/tmp/* /root/.cache/                                                 && \
    rm -rf /azure-cli/                                                                                      && \
    \
    echo -e "\n\n\n***** Azure-CLI version *****"                                                           && \
    az --version                                                                                            && \
    \
    echo -e "\n\n\n*********************************************\n\n"


# Customization
COPY common-files/  /
COPY azure-cli-python/files/  /
RUN echo "Europe/Paris" > /etc/timezone                     ; \
    chmod 640 /root/.bashrc                                 ; \
    chmod 644 /etc/localtime

ENV ENV /etc/profile
WORKDIR /root/
VOLUME ["/root/.azure/"]

CMD ["bash"]
