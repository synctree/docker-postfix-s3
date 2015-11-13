#!/bin/bash
service postfix restart
tail -f /var/log/mail.log