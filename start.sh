#!/bin/bash

# Start Tailscale
echo "Start Tailscale D"
tailscaled --tun=userspace-networking --socks5-server=localhost:1055 --outbound-http-proxy-listen=localhost:1055 > /dev/null 2>&1 &
echo "Wait"
sleep 2;
echo "Login to tailscale"
tailscale up --ssh --authkey $TAILSCALE_AUTHKEY --hostname=mumax
tailscale serve --bg http://127.0.0.1:35367

echo "***************"
echo "Machine Name:"
tailscale status | head -n 1 | awk '{print $2}'

# Wait forever
while true; do sleep 1000; done