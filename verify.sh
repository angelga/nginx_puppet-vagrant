#!/usr/bin/env bash

echo "Do post configuration checks"
response=`curl -s -w "%{http_code}\n" "http://localhost:8000" -o /dev/null | grep -c 200`
if [ $response -eq 1 ]; then
    echo "Nginx configured successfully"
    exit 0
else
    echo "Nginx configuration failed, unable to browse http://localhost:8000"
    exit 1
fi
