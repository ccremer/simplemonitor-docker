#!/bin/sh


# check if html is empty. If not, copy from default and chown
echo "Checking if $MONITOR_HTML_FOLDER has contents..."
if [ ! "$(ls -A $MONITOR_HTML_FOLDER)" ]; then
        echo "Copying default files..."
        cp -r "$DEFAULT_HTML_FOLDER/." "$MONITOR_HTML_FOLDER/"
        chown -R $NGINX_USER:$NGINX_USER "$MONITOR_HTML_FOLDER"
fi

# check if config folder is empty. If not, provide a default one and chown
echo "Checking if $MONITOR_CONFIG_FOLDER has contents..."
if [ ! "$(ls -A $MONITOR_CONFIG_FOLDER)" ]; then
        echo "Copying default config..."
        cp -r "$DEFAULT_CONFIG_FOLDER/." "$MONITOR_CONFIG_FOLDER/"
        chown -R $MONITOR_USER:$MONITOR_USER "$MONITOR_CONFIG_FOLDER/."
        echo "Created $MONITOR_CONFIG_FOLDER/monitors.ini and global.ini. Check your settings!"
fi

# start supervisor
supervisord -c /etc/supervisor/supervisord.conf

