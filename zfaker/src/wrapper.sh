#!/bin/sh

# z-push search for config.json in current dir
cd /usr/share/webtop/z-push/

# Remove dirty arguments
shift

php z-push-admin.php $@
