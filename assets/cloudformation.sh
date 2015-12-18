#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
/bin/bash /opt/docker-postfix-s3/assets/build.sh
/bin/bash /opt/docker-postfix-s3/assets/install.sh
sed -e 's/nodaemon=true/nodaemon=false/' -i /etc/supervisor/conf.d/supervisord.conf
service supervisor restart
