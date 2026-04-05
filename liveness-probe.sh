#!/bin/sh
# Liveness probe script - checks if configured services are running

EXIT_CODE=0

# Check owserver if it should be running
if [ -f "${OWSERVER_CONFIG:-}" ]; then
    if ! pgrep -x "owserver" > /dev/null; then
        echo "ERROR: owserver is not running"
        EXIT_CODE=1
    else
        echo "OK: owserver is running"
    fi
fi

# Check knxd if it should be running
if [ -f "${KNXD_CONFIG:-}" ]; then
    if ! pgrep -x "knxd" > /dev/null; then
        echo "ERROR: knxd is not running"
        EXIT_CODE=1
    else
        echo "OK: knxd is running"
    fi
fi

exit $EXIT_CODE
