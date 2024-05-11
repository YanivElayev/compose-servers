#!/bin/bash

filepath="/shared/counter.txt"
set -m
nginx -g 'daemon off;' &
retry_delay=1
response_code="-1"
while [ "$response_code" != "200" ]; do  # wait for nginx to start
    response_code=$(curl -sL -w "%{http_code}\\n" "http://localhost" -o /dev/null)
    echo "Server response $response_code"
    if [ "$response_code" != "200" ]; then
        echo "Retrying in $retry_delay seconds..."
        sleep $retry_delay
    fi
done
echo "Server is up!"
if [ ! -f "$filepath" ]; then


    echo "1" > "$filepath"
else
    count=$(cat "$filepath")
    count=$((count + 1))
    echo "$count" > "$filepath"
fi

SERVER_NUMBER=$(cat "$filepath")
echo "$SERVER_NUMBER" > /usr/share/nginx/html/index.html
fg %1