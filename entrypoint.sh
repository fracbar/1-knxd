#!/bin/sh
set -e

OWSERVER_CONFIG="${OWSERVER_CONFIG:-/etc/owfs/owserver.conf}"
KNXD_CONFIG="${KNXD_CONFIG:-/etc/knxd.ini}"

# Flag to track if any service started
SERVICES_STARTED=0

# Start owserver if config file exists
if [ -f "$OWSERVER_CONFIG" ]; then
    echo "Starting owserver with config: $OWSERVER_CONFIG"
    owserver -c "$OWSERVER_CONFIG" &
    SERVICES_STARTED=$((SERVICES_STARTED + 1))
else
    echo "Warning: owserver config not found at $OWSERVER_CONFIG"
    echo "To enable owserver, mount a config file to: $OWSERVER_CONFIG"
fi

# Start knxd if KNXD_CONFIG is provided
if [ -f "$KNXD_CONFIG" ]; then
    echo "Starting knxd with config: $KNXD_CONFIG"
    eval "knxd $KNXD_CONFIG" &
    SERVICES_STARTED=$((SERVICES_STARTED + 1))
else
    echo "Warning: KNXD_CONFIG not set"
    echo "To enable knxd, mount a config file to: $KNXD_CONFIG"
fi

# Exit if no services were started
if [ $SERVICES_STARTED -eq 0 ]; then
    echo "Error: No services configured. Please provide:"
    echo "  - owserver config file at: $OWSERVER_CONFIG"
    echo "  - knxd config file at: $KNXD_CONFIG"
    exit 1
fi

# Wait for all background processes
wait
