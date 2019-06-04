#!/usr/bin/env bash

set -eo pipefail


AUTODESK_PATH="${HOME}/Library/Application Support/Autodesk"
FUSION_ADDINS="${AUTODESK_PATH}/Autodesk Fusion 360/API/AddIns"
CURDIR="$(pwd)"


function rm_addins() {
    for name in "$@"; do
        echo -n "${name}..."

        if [[ -d "${FUSION_ADDINS}/${name}" ]]; then
            rm -rf "${FUSION_ADDINS}/${name}"
            echo "DONE"
        else
            echo "NOT FOUND"
        fi
    done
}


echo -e "\nCleaning up...\n"

echo "AUTODESK_PATH -> ${AUTODESK_PATH}"
echo "FUSION_ADDINS -> ${FUSION_ADDINS}"
echo

if [[ "$@" == "" ]]; then
    FUSION_SITE_PACKAGES="${HOME}/Applications/Autodesk Fusion 360.app/Contents/Api/Python/packages"

    echo -e "Purge development and temporary files...\n"

    echo "FUSION_SITE_PACKAGES -> ${FUSION_SITE_PACKAGES}"
    echo

    find "${CURDIR}" \
        -name "*.py[cod]" -exec rm -f {} + -o \
        -name "__pycache__" -exec rm -rf {} + \
    && \
    rm -rf \
        "${CURDIR}/.cache" \
        "${CURDIR}/.mypy_cache" \
        "${CURDIR}/.pytest_cache" \
        "${CURDIR}/.venv" \
    && \
    find "${FUSION_SITE_PACKAGES}" \
        -mindepth 1 -maxdepth 1 \
        -type d \
            -not -name adsk \
            -exec rm -rf {} + -o \
        \
        -type f -exec rm -rf {} + \
    && \
    echo "DONE"
else
    # Remove addin(s) only.
    rm_addins "$@"
fi
