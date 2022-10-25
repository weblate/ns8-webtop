#!/bin/bash -e

#
# Copyright (C) 2022 Nethesis S.r.l.
# http://www.nethesis.it - nethserver@nethesis.it
#
# This script is part of NethServer.
#
# NethServer is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License,
# or any later version.
#
# NethServer is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with NethServer.  If not, see COPYING.
#

# initialize postgres requisites
for psql in `find /docker-entrypoint-initdb.d/postgres -name \*.sql | sort`
do
        echo "Loading: $psql ..."
        psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" < $psql >/dev/null
done

# initialize db schema in the following order
# 1. core
# 2. config
# 3. calendar
# 4. contacts
# 5. mail
# 6. tasks
# 7. vfs
#
# init-public.sql is obsolete
for sql in core config calendar contacts mail tasks vfs
do
    echo "Loading: $sql ..."
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB"  < /docker-entrypoint-initdb.d/schema/init-$sql.sql >/dev/null
done

# initialize db data
for dsql in `find /docker-entrypoint-initdb.d/data/ -name \*.sql | sort`
do
    echo "Loading: $dsql ..."
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" < $dsql >/dev/null
done
