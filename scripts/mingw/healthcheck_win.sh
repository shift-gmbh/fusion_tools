#!/usr/bin/env bash

set -eo pipefail

AUTODESK_PATH="/c/Documents and Settings/Administrator/AppData/Local/Autodesk/"
FUSION_SITE_PACKAGES="$(find "${AUTODESK_PATH}/webdeploy/production" -name Api -type d)"


echo -en "\nHealth checking Fusion's deploy..."

deploys_num="$(echo "${FUSION_SITE_PACKAGES}" | wc -l)"
echo -n "${deploys_num}"

if [[ $deploys_num -eq 1 ]]; then
    echo -e " OK\n"
    echo "AUTODESK_PATH -> ${AUTODESK_PATH}"
    echo "FUSION_SITE_PACKAGES -> ${FUSION_SITE_PACKAGES}"
else
    echo " FAILED"
fi
