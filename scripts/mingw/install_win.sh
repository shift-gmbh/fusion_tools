#!/usr/bin/env bash

set -eo pipefail

ADDIN_FILES=(
    "manifest"
    "py"
)
FUSION_ADDINS="/c/Users/Administrator/AppData/Roaming/Autodesk/Autodesk Fusion 360/API/AddIns"
CURDIR="$(pwd)"


function install_addins() {
    for name in "$@"; do
        mkdir -p "${FUSION_ADDINS}/${name}"

        for ext in ${ADDIN_FILES[*]}; do
            local item="${name}.${ext}"
            echo -n "${item}..."

            if [[ -f "${FUSION_ADDINS}/${name}/${name}.${ext}" ]]; then
                echo "SKIPPED (already installed)"
                continue
            fi
            if \
                cp "${CURDIR}/${name}.${ext}" "${FUSION_ADDINS}/${name}" 1>/dev/null 2>&1
            then
                echo "DONE"
            else
                echo "FAILED"
            fi
        done
    done
}


if [[ "$@" == "" ]]; then
    echo -e "\nERROR: At least one addin name must be given"
    exit 1
fi

echo -e "\nInstalling addin(s)...\n"

echo "FUSION_ADDINS -> ${FUSION_ADDINS}"
echo

install_addins "$@"
