#!/bin/bash

sed -i -E \
	-e "s/amp-.*?-blue/amp-${APP_VERSION}-blue/g" \
	README.md
