#!/bin/bash


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
        touch "$MONITOR_CONFIG_FOLDER/monitors.ini"
        cp "$DEFAULT_CONFIG_FILE" "$MONITOR_CONFIG_FILE"
        chown -R $MONITOR_USER:$MONITOR_USER "$MONITOR_CONFIG_FOLDER/."
        echo "$MONITOR_CONFIG_FOLDER/monitors.ini is empty. Create your monitors in here and check your settings in global.ini as well."
fi

# start supervisor
supervisord -c /etc/supervisor/supervisord.conf

