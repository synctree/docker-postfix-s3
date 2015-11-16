#!/bin/bash
service postfix restart
tail -f /tmp/filter.log