# About SimpleMonitor

[SimpleMonitor](http://jamesoff.github.io/simplemonitor/) by James Seward is a Python script which monitors hosts and network connectivity. It is designed to be quick and easy to set up and lacks complex features that can make things like Nagios, OpenNMS and Zenoss overkill for a small business or home network. Remote monitor instances can send their results back to a central location.

Give [jamesoff/simplemonitor](https://github.com/jamesoff/simplemonitor) a Star!

# About this Docker image

This docker image installs SimpleMonitor on Debian Stretch or Alpine and includes a nginx Webserver, where you can get the status of your hosts and services.

## Run it

I don't like `docker run` commands with a lot of arguments, so here's a sample `docker-compose` file:
```yml
version: '3.2'
services:
  simplemonitor:
    restart: always
    # use simplemonitor:alpine for an alpine image
    image: braindoctor/simplemonitor:latest
    container_name: simplemonitor
    hostname: simplemonitor.domain.local
    volumes:
      - /tmp/simplemonitor/config:/etc/simplemonitor
      - /tmp/simplemonitor/html:/usr/local/simplemonitor/html
    ports:
      - "8080:8080"
```
The default [docker-compose.yml](https://github.com/BrainDoctor/simplemonitor-docker/blob/master/docker-compose.yml) file has more detailed comments.

You should now be able to point your browser to `http://simplemonitor:8080` and retrieve a basic status HTML page:
![status html](https://user-images.githubusercontent.com/12159026/28783956-43d0d6a8-7612-11e7-9f0c-72c9ee758935.png)

`http://simplemonitor:8080/status.json` returns a JSON representation of the service status, if you want to poll it by a browser and create nice badges with javascript (or whatever). Do not expect the "API" to be stable though (some fields may change in future, watch the changelogs).
```json
{
    "generated":"2017-07-31 15:03:35",
    "monitors":{
        "localhost":{
            "status":"OK",
            "virtual_fail_count":0,
            "last_run_duration":0.0034890174865722656,
            "dependencies":[],
            "result":"0.037ms",
            "first_failure_time":""
        }
    }
}
```

## Configure it

1. First make sure that the volume paths to your docker-compose.yml are correct to make them persistent
2. Bring up the container by running `docker-compose up -d`. The default configuration is being copied to the locations above.
3. Stop the container by running `docker-compose stop`.
4. Modify `/path//to/your/simplemonitor/config/global.ini` as appropriate. See http://jamesoff.github.io/simplemonitor/configuration.html for reference.
5. Configure your services `/path//to/your/simplemonitor/config/monitors.ini`. See http://jamesoff.github.io/simplemonitor/monitors.html for reference.

# SSL Support

You have 2 options:

1. Edit `/etc/nginx/nginx.conf` and `/etc/nginx/conf.d/simplemonitor.conf` as needed. Make sure to make the changes persistent by mounting them from outside.
2. Or you could setup a reverse-proxy in front of this image. Check out the excellent [jwilder/nginx-proxy](https://hub.docker.com/r/jwilder/nginx-proxy/)!

# Other

This image and software has been designed with simplicity in mind, not for security or scalability. As always, use it at your own risk!
