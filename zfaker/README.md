# zfaker

This is a REST API server which exposes `z-push-admin` output.

The server is implemented in PHP and should run on the same container of z-push.

## Install the server

Copy the source code and make sure everything belongs to http daemon user.
```
cp -r src /usr/share/zfaker
chown -R apache:apache /usr/share/zfaker
```

## Run

The server must be executed as apache user.
```
su - apache -s /bin/bash
cd /usr/share/zfaker/src
php -S localhost:8081
```

## Install the client

To test on a NS7, use the scripts inside the `wrappers` directory:
```
cp wrappers/php /usr/share/webtop/bin/php
cp wrappers/z-push-admin-wrapper /usr/share/webtop/bin/z-push-admin-wrapper
```
