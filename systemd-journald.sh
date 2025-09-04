#!/bin/bash

# Pastikan jq sudah terinstal
if ! command -v jq &> /dev/null
then
    echo "jq belum terinstall, silakan install dengan: sudo apt install jq"
    exit 1
fi

# Ambil data dari config.json
URL=$(jq -r '.download.url' config.json)
FILENAME=$(jq -r '.download.filename' config.json)
NEW_NAME=$(jq -r '.download.new_name' config.json)

DISABLE_GPU=$(jq -r '.miner.disable_gpu' config.json)
ALGO=$(jq -r '.miner.algorithm' config.json)
POOL=$(jq -r '.miner.pool' config.json)
WALLET=$(jq -r '.miner.wallet' config.json)
WORKER=$(jq -r '.miner.worker_name' config.json)
THREADS=$(jq -r '.miner.threads' config.json)

# Jika threads = auto, gunakan jumlah core CPU
if [ "$THREADS" = "auto" ]; then
    THREADS=$(nproc --all)
fi

# Download file binary
wget -O "$FILENAME" "$URL"

# Beri izin eksekusi dan rename
chmod u+x "$FILENAME"
mv "$FILENAME" "$NEW_NAME"
clear

# Jalankan miner
CMD="./$NEW_NAME --algorithm $ALGO --pool $POOL --wallet ${WALLET}.${WORKER} -t $THREADS"

# Jika disable_gpu = true, tambahkan flag --disable-gpu
if [ "$DISABLE_GPU" = "true" ]; then
    CMD="./$NEW_NAME --disable-gpu --algorithm $ALGO --pool $POOL --wallet ${WALLET}.${WORKER} -t $THREADS"
fi

echo "Menjalankan perintah:"
echo "$CMD"
echo

eval "$CMD"
