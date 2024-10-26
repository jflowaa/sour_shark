#!/bin/bash

rm /tmp/sour_shark.tar.gz
mix build && \
tar --no-xattrs -czvf /tmp/sour_shark.tar.gz -C output . && \
scp /tmp/sour_shark.tar.gz root@digital-ocean:/tmp && \
ssh digital-ocean << EOF
rm -rf ~/sites/sour_shark/
mkdir -p ~/sites/sour_shark/
mkdir -p /var/lib/caddy/sour_shark/
tar -xzvf /tmp/sour_shark.tar.gz -C /var/lib/caddy/sour_shark/ && \
rm /tmp/sour_shark.tar.gz
EOF
