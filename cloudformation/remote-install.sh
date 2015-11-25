#!/bin/bash
set -xe
mkdir -p /opt/
git clone git@github.com:synctree/docker-postfix-s3.git /opt/docker-postfix-s3
bash /opt/docker-postfix-s3/assets/build.sh
bash /opt/docker-postfix-s3/assets/install.sh
sed -e 's/true/false/' -i /etc/supervisor/conf.d/supervisord.conf