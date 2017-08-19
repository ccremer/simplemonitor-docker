#!/bin/sh

if [ "$(find $MONITOR_HTML_FOLDER/status.json -mmin +$HEALTH_CHECK_INTERVAL)" != "" ]; then
    exit 1
fi
exit 0