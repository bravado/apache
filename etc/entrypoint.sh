#!/bin/bash

# Delete old pid files
/usr/bin/find /var/run/ -type f -name '*.pid' -delete

# Run entrypoint.d
for i in /etc/entrypoint.d/*.sh; do
    bash $i
done

# Check for local config and start supervisord
if [[ -f /etc/entrypoint.local.sh ]]; then
	/usr/bin/supervisord -c /etc/supervisor/supervisord.conf &
	source /etc/entrypoint.local.sh
else
	exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
fi
