#!/bin/sh
. /etc/profile.d/postfix-s3-envvars
SENDER="$1"
RECIPIENT="$2"
LOGFILE=/tmp/filter.log

WORKDIR=`mktemp -d /tmp/filter-$(date +%s)-XXXX`
cd $WORKDIR

# parse destination directory
aws --region us-east-1 s3 cp "s3://$WHITELIST_URI" "/tmp/postfix-s3-whitelist" >> /tmp/filter.log 2>&1
timestamp="$(date +%s)"

# unpacks the attachments read from stdin
munpack | while read line ; do
  filename="$(echo "$line" | cut -d\  -f1)"
  destination="$(grep "$RECIPIENT" /tmp/postfix-s3-whitelist | head -n1 | cut -d: -f2 | sed -e 's/ *//' | sed -e "s/%t/$timestamp/g" | sed -e "s/%n/$filename/g")"
  echo "Received mail with $@, attached file $filename" >> "$LOGFILE"
  aws --region us-east-1 s3 cp "$filename" "s3://$S3_BUCKET/$destination" >> /tmp/filter.log 2>&1
done

# clean up
rm -r "$WORKDIR"
