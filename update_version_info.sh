#!/bin/bash

OVERLAY_VERSION=$(cat package_versions.txt | grep -E "s6-overlay.*?-" | sed -n 1p | cut -c 12- | sed -E 's/-r.*//g')

OLD_OVERLAY_VERSION=$(cat version_info.json | jq -r .overlay_version)
OLD_AMP_VERSION=$(cat version_info.json | jq -r .amp_version)

sed -i \
  -e "s/${OLD_OVERLAY_VERSION}/${OVERLAY_VERSION}/g" \
  -e "s/${OLD_AMP_VERSION}/${AMP_VERSION}/g" \
  README.md

NEW_VERSION_INFO="overlay_version|amp_version
${OVERLAY_VERSION}|${AMP_VERSION}"

jq -Rn '
( input  | split("|") ) as $keys |
( inputs | split("|") ) as $vals |
[[$keys, $vals] | transpose[] | {key:.[0],value:.[1]}] | from_entries
' <<<"$NEW_VERSION_INFO" >version_info.json
