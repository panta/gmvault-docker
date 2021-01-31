FROM alpine:latest

MAINTAINER Marco Pantaleoni <marco.pantaleoni@gmail.com>

ENV LANG=C.UTF-8

# crontab(5) syntax
#  field         allowed values
#  -----         --------------
#  minute        0-59
#  hour          0-23
#  day of month  1-31
#  month         1-12 (or names, see below)
#  day of week   0-7 (0 or 7 is Sun, or use names)

# GMVAULT_DIR allows using a location that is not the default $HOME/.gmvault.
ENV GMVAULT_DIR="/data" \
	GMVAULT_EMAIL_ADDRESS="test@example.com" \
	GMVAULT_TIMEZONE="Europe/Rome" \
	GMVAULT_FULL_SYNC_SCHEDULE="1 3 * * 0" \
	GMVAULT_QUICK_SYNC_SCHEDULE="1 2 * * 1-6" \
	GMVAULT_DEFAULT_GID="9000" \
	GMVAULT_DEFAULT_UID="9000" \
	CRONTAB="/var/spool/cron/crontabs/gmvault" \
	GMVAULT_SYNC_ON_STARTUP="no"

VOLUME $GMVAULT_DIR
RUN mkdir -p /app

# Set up environment.
RUN apk add --update \
		bash \
		ca-certificates \
		mailx \
		py2-pip \
		python2 \
		ssmtp \
		shadow \
		su-exec \
		tzdata \
	&& pip install --upgrade pip \
	&& pip install gmvault \
	&& rm -rf /var/cache/apk/* \
	&& addgroup -g "$GMVAULT_DEFAULT_GID" gmvault \
	&& adduser \
		-H `# No home directory` \
		-D `# Don't assign a password` \
		-u "$GMVAULT_DEFAULT_UID" \
		-s "/bin/bash" \
		-G "gmvault" \
		gmvault

#
# Copy cron jobs.
COPY backup_quick.sh /app/
COPY backup_full.sh /app/

# Set up entry point.
COPY start.sh /app/
WORKDIR /app
ENTRYPOINT ["/app/start.sh"]
