#!/usr/bin/env bash

set -eo pipefail


PIP_PKGS=(
    "zerorpc"
)

AUTODESK_PATH="${HOME}/Library/Application Support/Autodesk"
FUSION_PYTHON="$(find "${AUTODESK_PATH}/webdeploy/shared/PYTHON" -name bin -type d)"
FUSION_SITE_PACKAGES="${HOME}/Applications/Autodesk Fusion 360.app/Contents/Api/Python/packages"

PYTHON="${FUSION_PYTHON}/python"
PYVENV="${FUSION_PYTHON}/pyvenv_"
VIRTUALENV="virtualenv"

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
echo "FUSION_SITE_PACKAGES -> ${FUSION_SITE_PACKAGES}"
echo

echo -e "Python facility:\n==="
"${PYTHON}" --version
echo


echo -e "Create a new virtual environment (Fusion hosted)...\n"

echo -n "Ensure an empty \`${VENV_PATH}\`..."
rm -rf "${VENV_PATH}" && echo "OK"

(cd "${FUSION_PYTHON}" && \
 \
  ${SED} "s/#\!.*//g" pyvenv > "${PYVENV}" && \
  ./python "${PYVENV}" --without-pip "${VENV_PATH}"
 )
echo

source "${VENV_PATH}/bin/activate"

# Install latest Pip.
if [[ ! -f "get-pip.py" ]]; then
    curl -s "https://bootstrap.pypa.io/get-pip.py" -o get-pip.py
fi
python get-pip.py
echo
pip --version
echo

# Install Pip packages (Fusion hosted).
for pkg in ${PIP_PKGS[*]}; do
    pip install "${pkg}"
done
echo -e "DONE\n"


echo -e "Stuff Fusion's site with the installed packages...\n"

for item in $(pip freeze | ${SED} "s/==.*//g"); do

    # Package naming differs from a package directory.
    if [[ "${item}" == "msgpack-python" ]]; then item="msgpack"; fi
    if [[ "${item}" == "pyzmq" ]]; then item="zmq"; fi

    (cd "$(find "${VENV_PATH}/lib" -name site-packages -type d)" && \
     \
      cp -R *${item}* "${FUSION_SITE_PACKAGES}" ; \
     )
    (cd "${FUSION_SITE_PACKAGES}" && rm -rf *.dist-info)
done
ls -al "${FUSION_SITE_PACKAGES}"
echo -e "DONE\n"


echo -e "Create a new virtual environment (app local)...\n"

echo -n "Ensure an empty \`${VENV_PATH}\`..."
rm -rf "${VENV_PATH}" && echo "OK"

${VIRTUALENV} -p python3 "${VENV_PATH}"
echo
source "${VENV_PATH}/bin/activate"
pip --version
echo

# Install Pip packages (app local).
for pkg in ${PIP_PKGS[*]}; do
    pip install "${pkg}"
done
echo -e "DONE\n"
pip list
