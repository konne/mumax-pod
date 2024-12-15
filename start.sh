#!/bin/bash

# Start Tailscale
tailscale up --ssh --authkey $TAILSCALE_AUTHKEY
tailscale serve --bg http://127.0.0.1:35367

# Wait forever
while true; do sleep 1000; done