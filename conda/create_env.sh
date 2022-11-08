#!/bin/bash

set -x

cd /home/travis || exit

# shellcheck disable=SC1090
curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest | tar -xvj bin/micromamba

# Set up the shell for micromamba: adds some wrapper bash functions to the env
eval "$(./bin/micromamba shell hook --shell=bash)"

cd "${TEST_PATH}" || exit

# Create the directory where our environments are stored, equivalent to miniconda's ~/miniconda3
mkdir ~/micromamba

# Activate our empty env and set up channel config
micromamba activate
micromamba config set always_yes yes
micromamba config set changeps1 no
micromamba config set channel_priority strict
micromamba config remove channels defaults
micromamba config prepend channels pcds-tag
micromamba config prepend channels conda-forge
micromamba config prepend channels "file://$(pwd)/bld-dir"

# Useful for debugging
micromamba info
micromamba config list
echo "Conda Environment Name':' ${CONDA_ENV_NAME:=testenv}"
echo "Conda Requirements':' ${CONDA_REQUIREMENTS:=dev-requirements.txt}"
echo "Conda packages installed for CI':' ${CONDA_CI_PACKAGES:=pytest-cov}"

# Manage conda environment
# shellcheck disable=SC2086
micromamba create -n ${CONDA_ENV_NAME} python=$PYTHON_VERSION ${CONDA_PACKAGE} ${CONDA_EXTRAS} ${CONDA_CI_PACKAGES} --file ${CONDA_REQUIREMENTS}
micromamba activate ${CONDA_ENV_NAME}

# Useful for debugging
micromamba list
