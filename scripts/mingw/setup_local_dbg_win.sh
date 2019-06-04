#!/usr/bin/env bash

set -eo pipefail


PIP_PKGS=(
    "ipdb"
    "ipython"
    "mypy"
    "pylint"
)

AUTODESK_PATH="/c/Documents and Settings/Administrator/AppData/Local/Autodesk/"
FUSION_PYTHON="$(find "${AUTODESK_PATH}/webdeploy/shared/PYTHON" -name Python -type d)"
PATH="${FUSION_PYTHON}":${PATH}


CURDIR="$(pwd)"
VENV_PATH="${CURDIR}/.venv"

echo -e "\nSetting up local debug environment...\n"

echo "AUTODESK_PATH -> ${AUTODESK_PATH}"
echo "FUSION_PYTHON -> ${FUSION_PYTHON}"
echo

source "${VENV_PATH}/Scripts/activate"
pip --version
python -c 'import ssl ; print(ssl.OPENSSL_VERSION)'
echo

for pkg in ${PIP_PKGS[*]}; do
    pip install -U "${pkg}"
done
echo -e "DONE\n"
pip list
