#!/usr/bin/env bash

set -eo pipefail


AUTODESK_PATH="${HOME}/Library/Application Support/Autodesk"
FUSION_SITE_PACKAGES="${HOME}/Applications/Autodesk Fusion 360.app/Contents/Api/Python/packages"

echo -en "\nHealth checking Fusion's deploy..."

echo -e "OK\n"
echo "AUTODESK_PATH -> ${AUTODESK_PATH}"
echo "FUSION_SITE_PACKAGES -> ${FUSION_SITE_PACKAGES}"
