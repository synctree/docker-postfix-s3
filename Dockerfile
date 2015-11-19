From ubuntu:trusty
MAINTAINER Bryan Conrad

# Set noninteractive mode for apt-get
ENV DEBIAN_FRONTEND noninteractive

# Update
RUN apt-get update

# Install packages here so they're preserved in the cache
RUN apt-get -y install supervisor postfix mpack ruby2.0 awscli mailutils

RUN adduser filter --disabled-password --no-create-home
RUN mkdir /var/spool/filter
RUN chown filter:filter /var/spool/filter

# Stage scripts and config files
ADD assets/ /opt/

# Run
EXPOSE 25
CMD /opt/install.sh && /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
