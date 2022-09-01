# syntax=docker/dockerfile:1.4
# vi: syntax=Dockerfile

FROM travisci/ci-ubuntu-1804:packer-1662039951-ea1b7368

RUN curl -sSf --retry 5 -o python-3.9.tar.bz2 https://storage.googleapis.com/travis-ci-language-archives/python/binaries/ubuntu/16.04/x86_64/python-3.9.tar.bz2
RUN sudo tar xjf python-3.9.tar.bz2 --directory /

RUN sudo apt-get -y update
RUN sudo apt-get -y install herbstluftwm libxkbcommon-x11-0 gdb

USER travis
WORKDIR /home/travis

ARG ORG=pcdshub
ARG REPO=
ARG BRANCH=master
ARG PIP_EXTRAS

ENV TEST_PATH=/home/travis/${ORG}/${REPO}

ENV CI_ORG="${ORG}"
ENV CI_BRANCH="${BRANCH}"
ENV CI_REPO="${BRANCH}"

ENV OFFICIAL_REPO="pcdshub/${REPO}"
ENV DOCTR_VERSIONS_MENU="1"
ENV DOCS_REQUIREMENTS="dev-requirements.txt"
ENV PYTHON_LINT_OPTIONS="${IMPORT_NAME}"
ENV CONDA_PACKAGE="${REPO}"
ENV CONDA_RECIPE_FOLDER="conda-recipe"
ENV CONDA_EXTRAS="pip"
ENV CONDA_REQUIREMENTS="dev-requirements.txt"
ENV PIP_EXTRAS="${PIP_EXTRAS}"
ENV MPLBACKEND=agg

RUN git clone --branch=${BRANCH} --depth=1 https://github.com/${ORG}/${REPO}.git ${TEST_PATH}

WORKDIR ${TEST_PATH}

COPY install.sh ./install.sh
RUN ./install.sh

COPY test.sh ./test.sh

ENTRYPOINT ["/bin/bash", "--login", "-c"]
CMD ["./test.sh"]
