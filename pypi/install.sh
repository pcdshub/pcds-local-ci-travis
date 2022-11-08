#!/bin/bash

# shellcheck disable=SC1090
source ~/virtualenv/python3.9/bin/activate

python --version

pip install -v --upgrade pip
echo "Req File':' ${REQUIREMENTS:=requirements.txt}"
echo "Dev Req File':' ${DEV_REQUIREMENTS:=dev-requirements.txt}"
echo "Pip packages installed for CI':' ${PIP_CI_PACKAGES:=pytest-cov}"

# Install requirements
if [[ ! -f "${REQUIREMENTS}" ]]; then
    echo "File not found: ${REQUIREMENTS}" 1>&2
    travis_terminate 1
else
    pip install -v --requirement "${REQUIREMENTS}"
fi

# Install development requirements
if [[ ! -f "${DEV_REQUIREMENTS}" ]]; then
    echo "File not found: ${DEV_REQUIREMENTS}" 1>&2
    travis_terminate 1
else
    pip install -v --requirement "${DEV_REQUIREMENTS}"
fi

# Install Extras such as PyQt5
if [[ -n "${PIP_EXTRAS}" ]]; then
    echo "Installing extra pip dependencies."
    # shellcheck disable=SC2086
    pip install -v ${PIP_EXTRAS}
fi

# Install Extras such as PyQt5
if [[ -n "${PIP_CI_PACKAGES}" ]]; then
    echo "Installing pip dependencies for CI."
    pip install -v ${PIP_CI_PACKAGES}
fi

