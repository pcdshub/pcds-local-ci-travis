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

# Useful for debugging
micromamba info
micromamba config list

# boa is the mamba equivalent of conda-build and provides the conda mambabuild command
micromamba install boa

echo "Conda Recipe Folder':' ${CONDA_RECIPE_FOLDER}"
echo "DEBUG RECIPE:"
cat "${CONDA_RECIPE_FOLDER}/meta.yaml"
conda mambabuild -q "$CONDA_RECIPE_FOLDER" --output-folder bld-dir --no-anaconda-upload
