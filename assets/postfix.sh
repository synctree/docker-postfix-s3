#!/bin/bash
service postfix restart
touch /tmp/filter.log
chown filter:filter /tmp/filter.log
tail -f /tmp/filter.log