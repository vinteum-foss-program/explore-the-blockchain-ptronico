# Only one single output remains unspent from block 123,321. What address was it sent to?
# expected: 1FPDNNmgwEnKuF7GQzSqUcVQdzSRhz4pgX
blockhash=$(bitcoin-cli getblockhash 123321)

# Explicação: o bitcoin-core mantém o UTXO set de todas as transações. Portanto é possível
# consultar as informações de todas as outputs do bloco no UTXO set do bitcoin-core e saber
# se a output foi gasta ou não.

# Iterar por  todas as outputs, de todas as transaçoes do bloco e consultar a gettxout.
# Se o retorno for `null` a output já foi gasta, caso contrário, retornar o endereço.
# bitcoin-cli gettxout <txid> <n> ==>

txlist=$(bitcoin-cli getblock $blockhash 2 | jq '.tx')
echo "$txlist" | jq -c '.[]' | tail -n +3 | while read tx; do
    txid=$(echo "$tx" | jq -r '.txid');
    echo "$tx" | jq -c '.vout[]' | while read vout; do
        n=$(echo "$vout" | jq -r '.n');
        utxo=$(bitcoin-cli gettxout "$txid" "$n");
        if [ -n "$utxo" ]; then
            address=$(echo "$utxo" | jq -r '.scriptPubKey.address')
            echo "$address";
        fi
    done;
done
