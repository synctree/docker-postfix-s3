From ubuntu:trusty
MAINTAINER Bryan Conrad

ADD assets/build.sh /opt/docker-postfix-s3/assets/build.sh
RUN /bin/bash /opt/docker-postfix-s3/assets/build.sh

# Stage scripts and config files
ADD assets/ /opt/docker-postfix-s3/assets/

# Run
EXPOSE 25
CMD /opt/docker-postfix-s3/assets/install.sh && /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
