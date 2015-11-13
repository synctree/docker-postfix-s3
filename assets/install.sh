#!/bin/bash
set -e
set -x

#judgement
# if [[ -a /etc/supervisor/conf.d/supervisord.conf ]]; then
#   exit 0
# fi

if [[ -z "$maildomain" || -z "$S3_BUCKET" ]] ; then
  echo "You must set \$maildomain and \$S3_BUCKET for this container to be useful"
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
postconf -e myhostname=$maildomain

# defaults to 500MB
postconf -e message_size_limit=${max_attachment_size:-509600000}
postconf -F '*/*/chroot = n'
