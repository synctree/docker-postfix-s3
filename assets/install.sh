#!/bin/bash
set -e
set -x

# check for important vars
if [[ -z "$MAIL_DOMAIN" || -z "$S3_BUCKET" ]] ; then
  echo "You must set \$MAIL_DOMAIN and \$S3_BUCKET for this container to be useful"
fi

# defaults to 500MB
export MAX_ATTACHMENT_SIZE=${MAX_ATTACHMENT_SIZE:-509600000}

# save env vars for scripts to use
cat > /etc/profile.d/postfix-s3-envvars <<EOF
MAIL_DOMAIN=$MAIL_DOMAIN
MAX_ATTACHMENT_SIZE=$MAX_ATTACHMENT_SIZE
S3_BUCKET=$S3_BUCKET
EOF

chmod a+rx /etc/profile.d/postfix-s3-envvars

# install config and script files
cp /opt/docker-postfix-s3/assets/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
cp /opt/docker-postfix-s3/assets/master.cf /etc/postfix/master.cf
chmod +x /opt/docker-postfix-s3/assets/filter.sh
chmod +x /opt/docker-postfix-s3/assets/postfix.sh

# set up global postfix filter script
postconf -e content_filter=filter:dummy

# allows delivery of SMTP mail
postconf -e message_size_limit=$MAX_ATTACHMENT_SIZE
postconf -e myhostname=${MAIL_DOMAIN%.}
postconf -e mydestination=\$myhostname,localhost
postconf -e receive_override_options=no_unknown_recipient_checks
postconf -F '*/*/chroot = n'
