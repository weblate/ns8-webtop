#!/bin/bash

#
# Copyright (C) 2024 Nethesis S.r.l.
# SPDX-License-Identifier: GPL-3.0-or-later
#

set -e

PBHOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"

cd "$PBHOME"

CLASSPATH="lib/*:classes"
export PATH CLASSPATH

# Expand the Pecbridge configuration file template:
sed -e "s/WEBAPP_API_TOKEN/${WEBAPP_API_TOKEN:?}/" \
    ${PECBRIDGE_ADMIN_MAIL:+-e "1 s/sonicle-pec-bridge /sonicle-pec-bridge adminMail=\"${PECBRIDGE_ADMIN_MAIL}\" /"} \
    etc/config.xml.template > etc/config.xml

# Start the Pecbridge process
exec java com.sonicle.pecbridge.Main etc/config.xml
