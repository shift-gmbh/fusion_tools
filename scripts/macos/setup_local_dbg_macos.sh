#!/usr/bin/env bash

set -eo pipefail


PIP_PKGS=(
    "ipdb"
    "ipython"
    "mypy"
    "pylint"
)


CURDIR="$(pwd)"
VENV_PATH="${CURDIR}/.venv"

echo -e "\nSetting up local debug environment...\n"

echo "LDFLAGS -> ${LDFLAGS}"
echo "CPPFLAGS -> ${CPPFLAGS}"
echo "PKG_CONFIG_PATH -> ${PKG_CONFIG_PATH}"
echo

source "${VENV_PATH}/bin/activate"
pip --version
python -c 'import ssl ; print(ssl.OPENSSL_VERSION)'
echo

for pkg in ${PIP_PKGS[*]}; do
    pip install -U "${pkg}"
done
echo -e "DONE\n"
pip list
