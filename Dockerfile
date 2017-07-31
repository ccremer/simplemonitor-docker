FROM python:2.7-stretch

ENV \
	GIT_URL="https://github.com/BrainDoctor/simplemonitor.git" \
	MONITOR_FOLDER="/simplemonitor" \
	DEFAULT_CONFIG_FOLDER="/etc/default/simplemonitor" \
	DEFAULT_HTML_FOLDER="/etc/default/simplemonitor/html" \
	DEFAULT_CONFIG_FILE="/etc/default/simplemonitor/monitor.ini" \
	MONITOR_CONFIG_FOLDER="/simplemonitor/config" \
	MONITOR_CONFIG_FILE="/simplemonitor/config/global.ini" \
	MONITOR_HTML_FOLDER="/simplemonitor/html" \
	NGINX_USER="www-data" \
	MONITOR_USER="www-data"

RUN \
	apt-get update && \
	apt-get install --no-install-recommends -y \
		supervisor \
		nginx \
	&& apt-get clean && \
	git clone $GIT_URL && \
	pip install -r $MONITOR_FOLDER/requirements.txt && \
	rm -r "$MONITOR_FOLDER/.git" && \
	mkdir -p "$DEFAULT_CONFIG_FOLDER" && \
	mv "$MONITOR_HTML_FOLDER" "$DEFAULT_HTML_FOLDER"

COPY files /
VOLUME /simplemonitor/config /simplemonitor/html
WORKDIR $MONITOR_FOLDER
EXPOSE 8080
ADD docker-entrypoint.sh $MONITOR_FOLDER/

ENTRYPOINT ["/bin/bash"]
CMD ["docker-entrypoint.sh"]
