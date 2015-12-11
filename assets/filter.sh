#!/bin/sh
. /etc/profile.d/postfix-s3-envvars
SENDER="$1"
RECIPIENT="$2"
LOGFILE=/tmp/filter.log

WORKDIR=`mktemp -d /tmp/filter-$(date +%s)-XXXX`
cd $WORKDIR

# parse destination directory
aws --region us-east-1 s3 cp "$WHITELIST_URI" "/tmp/postfix-s3-whitelist" >> /tmp/filter.log 2>&1
directory="$(grep "$SENDER" /tmp/postfix-s3-whitelist | head -n1 | cut -d: -f2 | sed -e 's/ *//')"

# unpacks the attachments read from stdin
munpack | while read line ; do
  filename="$(echo "$line" | cut -d\  -f1)"
  echo "Received mail with $@, attached file $filename" >> "$LOGFILE"
  aws --region us-east-1 s3 cp "$filename" "s3://$S3_BUCKET/$directory/$(date +%s)-$filename" >> /tmp/filter.log 2>&1
done

# clean up
rm -r "$WORKDIR"
