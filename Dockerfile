FROM python:2.7-stretch

ENV \
	GIT_URL="https://github.com/BrainDoctor/simplemonitor.git" \
	MONITOR_FOLDER="/usr/local/simplemonitor" \
	MONITOR_ARGS="-H" \
	DEFAULT_CONFIG_FOLDER="/etc/default/simplemonitor" \
	DEFAULT_HTML_FOLDER="/etc/default/simplemonitor/html" \
	DEFAULT_CONFIG_FILE="/etc/default/simplemonitor/global.ini" \
	MONITOR_CONFIG_FOLDER="/etc/simplemonitor" \
	MONITOR_CONFIG_FILE="/etc/simplemonitor/global.ini" \
	MONITOR_HTML_FOLDER="/usr/local/simplemonitor/html" \
	NGINX_USER="www-data" \
	MONITOR_USER="www-data"

RUN \
	apt-get update && \
	apt-get install --no-install-recommends -y \
		supervisor \
		nginx \
		dnsutils \
	&& apt-get clean && \
	git clone $GIT_URL /tmp/simplemonitor && \
	rm -r /tmp/simplemonitor/.git && \
	mv /tmp/simplemonitor "$MONITOR_FOLDER" && \
	pip install -r $MONITOR_FOLDER/requirements.txt && \
	mkdir -p "$DEFAULT_CONFIG_FOLDER" && \
	mv "$MONITOR_HTML_FOLDER" "$DEFAULT_HTML_FOLDER"

COPY files /
VOLUME $MONITOR_CONFIG_FOLDER $MONITOR_HTML_FOLDER
WORKDIR $MONITOR_FOLDER
EXPOSE 8080
ADD docker-entrypoint.sh $MONITOR_FOLDER/

#ENTRYPOINT ["/bin/bash"]
CMD ["/bin/sh", "docker-entrypoint.sh"]
