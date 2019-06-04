#!/usr/bin/env bash

set -eo pipefail

PIP_PKGS=(
    "zerorpc"
)

AUTODESK_PATH="/c/Documents and Settings/Administrator/AppData/Local/Autodesk/"
FUSION_PYTHON="$(find "${AUTODESK_PATH}/webdeploy/shared/PYTHON" -name Python -type d)"
FUSION_PYTHON_SCRIPTS="${FUSION_PYTHON}/Scripts"

PYTHON="${FUSION_PYTHON}/python.exe"
PIP="${FUSION_PYTHON_SCRIPTS}/pip.exe"

FUSION_SITE_PACKAGES="$(find "${AUTODESK_PATH}/webdeploy/production" -name Api -type d)"
FUSION_SITE_PACKAGES+="/Python/packages"

OS_NAME="$(uname -s)"

if [[ "${OS_NAME}" == "Darwin" ]]; then
    SED="gsed"
else
    SED="sed"
fi


CURDIR="$(pwd)"
VENV_PATH="${CURDIR}/.venv"

echo -e "\nSetting up environment on ${OS_NAME}...\n"

echo "AUTODESK_PATH -> ${AUTODESK_PATH}"
echo "FUSION_PYTHON -> ${FUSION_PYTHON}"
echo "FUSION_PYTHON_SCRIPTS -> ${FUSION_PYTHON_SCRIPTS}"
echo "FUSION_SITE_PACKAGES -> ${FUSION_SITE_PACKAGES}"
echo

echo -e "Python facility:\n==="
"${PYTHON}" --version
echo

# Install latest Pip.
if [[ ! -f "get-pip.py" ]]; then
    curl -s "https://bootstrap.pypa.io/get-pip.py" -o get-pip.py
fi
"${PYTHON}" get-pip.py
echo
"${PIP}" --version
echo

PATH="${FUSION_PYTHON}":${PATH}
"${PIP}" install -U virtualenv || :

VIRTUALENV="${FUSION_PYTHON_SCRIPTS}/virtualenv.exe"
echo "Virtualenv $("${VIRTUALENV}" --version)"
echo


echo -e "Create a new virtual environment...\n"

echo -n "Ensure an empty \`${VENV_PATH}\`..."
rm -rf "${VENV_PATH}" && echo "OK"

"${VIRTUALENV}" "${VENV_PATH}"
source "${VENV_PATH}/Scripts/activate"

# Install Pip packages.
for pkg in ${PIP_PKGS[*]}; do
    pip install "${pkg}"
done
echo -e "DONE\n"


echo -e "Stuff Fusion's site with the installed packages...\n"

for item in $(pip freeze | ${SED} "s/==.*//g"); do

    # Package naming differs from a package directory.
    if [[ "${item}" == "msgpack-python" ]]; then item="msgpack"; fi
    if [[ "${item}" == "pyzmq" ]]; then item="zmq"; fi

    (cd "${VENV_PATH}/Lib/site-packages/" && \
     \
      cp -R *${item}* "${FUSION_SITE_PACKAGES}" ; \
     )
    (cd "${FUSION_SITE_PACKAGES}" && rm -rf *.dist-info)
done
ls -al "${FUSION_SITE_PACKAGES}"
echo "DONE"
