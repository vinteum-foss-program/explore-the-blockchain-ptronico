# Which tx in block 257,343 spends the coinbase output of block 256,128?
# expected: c54714cb1373c2e3725261fe201f267280e21350bdf2df505da8483a6a4805fc
blockhash=$(bitcoin-cli getblockhash 256128)
coinbase_txid=$(bitcoin-cli getblock "$blockhash" 1 | jq -r '.tx[0]')

blockhash2=$(bitcoin-cli getblockhash 257343)
txlist=$(bitcoin-cli getblock $blockhash2 2 | jq '.tx')

echo "$txlist" | jq -c '.[]' | tail -n +3 | while read tx; do
    txid=$(echo "$tx" | jq -r '.txid');
    echo "$tx" | jq -c '.vin[]' | while read vin; do
        vin_txid=$(echo "$vin" | jq -r '.txid');
        if [ "$coinbase_txid" == "$vin_txid" ]; then
            echo $txid;
        fi
    done;
done
