FROM alpine:latest

USER root

# --
RUN apk update \
	&& apk upgrade \
	&& apk --no-cache add dcron libcap

# -- User setup
RUN addgroup -g 2001 pentaho \
	&& adduser -u 1001 -G pentaho -D -h /home/pentaho pentaho

# -- Security Settings for CRONTAB/CROND:
RUN setcap cap_setgid=ep /usr/bin/crontab \
	&& setcap cap_setgid=ep /usr/sbin/crond

RUN chmod 755 /usr/sbin/crond
RUN chmod 755 /usr/bin/crontab
RUN chmod 777 /etc/crontabs

# -- Copy the user's crontab file. This will also appear
# -- in the `/var/spool/cron/crontab` directory as well
COPY --chown=pentaho:pentaho crontab /etc/crontabs/pentaho

# --- Setting up the application/user environment...
COPY --chown=pentaho:pentaho entrypoint.sh /home/pentaho/entrypoint.sh
RUN chmod 755 /home/pentaho/entrypoint.sh

USER pentaho
WORKDIR /home/pentaho
ENTRYPOINT [ "./entrypoint.sh" ]

