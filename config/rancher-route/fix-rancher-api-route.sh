#!/bin/bash

# Define variables
IP="10.231.0.100"
GW="192.168.1.254"
LOG_TAG="fix-rancher-api-route"

# Find the first default route's network interface
DEFAULT_IF=$(ip route | grep '^default' | awk '{print $5}' | head -n1)

if [ -z "$DEFAULT_IF" ]; then
  logger -t "$LOG_TAG" "No default interface found. Exiting."
  exit 1
fi

# Get the current gateway for the $IP route (if any)
CURRENT_ROUTE=$(ip route get "$IP" 2>/dev/null | grep -oP 'via \K[\d.]+' || echo "")

# Track if any changes are made
CHANGED=0

# If there is no route for $IP
if [ -z "$CURRENT_ROUTE" ]; then
  logger -t "$LOG_TAG" "No route found for $IP, adding correct route via $GW."
  ip route add "$IP"/32 via "$GW" dev "$DEFAULT_IF" metric 0
  CHANGED=1
# If the current route points to the wrong gateway
elif [ "$CURRENT_ROUTE" != "$GW" ]; then
  logger -t "$LOG_TAG" "Wrong route detected: $IP via $CURRENT_ROUTE on $DEFAULT_IF, fixing..."
  ip route del "$IP"/32 via "$CURRENT_ROUTE" dev "$DEFAULT_IF"
  ip route add "$IP"/32 via "$GW" dev "$DEFAULT_IF" metric 0
  logger -t "$LOG_TAG" "Correct route added: $IP via $GW on $DEFAULT_IF."
  CHANGED=1
fi

# Exit cleanly
exit 0