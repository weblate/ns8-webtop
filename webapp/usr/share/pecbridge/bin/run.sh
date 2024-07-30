#!/bin/bash

#
# Copyright (C) 2024 Nethesis S.r.l.
# SPDX-License-Identifier: GPL-3.0-or-later
#

PBHOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"

cd "$PBHOME"

CLASSPATH=lib/*:classes
export PATH CLASSPATH

# Parse the webtop.properties file to extract the API token value:
WEBAPP_API_TOKEN=$(awk -F = '/^webtop\.provisioning\.api\.token/ { print $2 }' /etc/webtop/webtop.properties)

# Expand the Pecbridge configuration file template:
sed "s/WEBAPP_API_TOKEN/${WEBAPP_API_TOKEN:?}/" etc/config.xml.template > etc/config.xml

# Start the Pecbridge process
exec java com.sonicle.pecbridge.Main etc/config.xml
