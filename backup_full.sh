#!/bin/bash

echo "Starting full sync of $GMVAULT_EMAIL_ADDRESS."

if [ "$GMVAULT_SEND_REPORTS_TO" != "" ] ; then
	echo "Report will be sent to $GMVAULT_SEND_REPORTS_TO."
	gmvault sync -d "${GMVAULT_DIR}" $GMVAULT_OPTIONS $GMVAULT_EMAIL_ADDRESS 2>&1 \
		| tee "${GMVAULT_DIR}/${GMVAULT_EMAIL_ADDRESS}_full.log" \
		| mail -s "Mail Backup (full) | $GMVAULT_EMAIL_ADDRESS | `date +'%Y-%m-%d %r %Z'`" $GMVAULT_SEND_REPORTS_TO
else
	gmvault sync -d "${GMVAULT_DIR}" $GMVAULT_OPTIONS $GMVAULT_EMAIL_ADDRESS 2>&1 \
		| tee "${GMVAULT_DIR}/${GMVAULT_EMAIL_ADDRESS}_full.log"
fi

echo "Full sync complete."
