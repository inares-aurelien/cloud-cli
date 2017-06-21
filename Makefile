# https://www.gnu.org/software/make/manual/make.html
SHELL = /bin/bash
NAME	= aureliend
CLI_LIST = aws-cli-python azure-cli-python azure-cli-node


.PHONY: default all $(CLI_LIST) clean tidy pushdocker

default: all
all: $(CLI_LIST)

$(CLI_LIST):
	@source $@/.version && \
			if [ $$TRAVIS ] ; then \
				BUILD=$$TRAVIS_BUILD_NUMBER ; \
			else \
				BUILD=`expr $$BUILD + 1` ; \
			fi ; \
			message="***** Build $@ $$VERSION.$$BUILD *****" ; \
			length=$${#message} ; \
			stars=$$(head -c "$$length" < /dev/zero | tr '\0' '*') ; \
			echo -e "\n\n\n$$stars\n$$message\n$$stars\n" ; \
			echo -e "VERSION=$$VERSION\nBUILD=$$BUILD" > $@/.version && \
			docker build -t $(NAME)/$@:$$VERSION.$$BUILD --compress -f $@/Dockerfile --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` --build-arg VCS_REF=`git rev-parse --short HEAD` . && \
			docker tag $(NAME)/$@:$$VERSION.$$BUILD $(NAME):latest && \
			echo -e "\n\n"


clean:
	@echo -e "\n\n***** Clean up any failed $(NAME) builds *****"
	@for i in `docker images -q -f dangling=true`; do \
			for j in `docker ps -q -f status=exited -f ancestor=$$i`; do \
					docker rm $$j ; \
			done ; \
			docker rmi $$i ; \
	done

tidy:
	@echo -e "\n\n***** Tidying up any images older than $(NAME):latest *****"
	@LATEST=`docker images -q $(NAME):latest` && \
			[ -n "$$LATEST" ] && \
			for i in `docker images -q $(NAME) | tac | uniq`; do \
					[ $$i = $$LATEST ] && break || docker rmi $$i ; \
			done

pushdocker:
	@echo -e "\n\n***** Push images to docker hub *****\n"
	@for myTag in $(CLI_LIST) ; do \
			docker push $(NAME)/$$myTag ; \
	done
