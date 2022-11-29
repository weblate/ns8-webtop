#!/bin/bash -e

#
# Copyright (C) 2022 Nethesis S.r.l.
# SPDX-License-Identifier: GPL-3.0-or-later
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
