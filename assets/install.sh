#!/bin/bash
set -e
set -x

#judgement
# if [[ -a /etc/supervisor/conf.d/supervisord.conf ]]; then
#   exit 0
# fi

if [[ -z "$MAIL_DOMAIN" || -z "$S3_BUCKET" ]] ; then
  echo "You must set \$MAIL_DOMAIN and \$S3_BUCKET for this container to be useful"
  exit 1
fi
chmod +x /opt/interpolate.rb

# install config and script files
ruby /opt/interpolate.rb /opt/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ruby /opt/interpolate.rb /opt/master.cf /etc/postfix/master.cf
ruby /opt/interpolate.rb /opt/filter.sh.erb /opt/filter.sh

chmod +x /opt/filter.sh
chmod +x /opt/postfix.sh

postconf -e content_filter=filter:dummy
postconf -e myhostname=$MAIL_DOMAIN

# defaults to 500MB
postconf -e message_size_limit=${MAX_ATTACHMENT_SIZE:-509600000}
postconf -F '*/*/chroot = n'
