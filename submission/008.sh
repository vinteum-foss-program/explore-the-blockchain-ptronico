# Which public key signed input 0 in this tx:
#   `e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163`
witness=$(bitcoin-cli getrawtransaction e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163 1 | jq -r '.vin[] | .txinwitness[2]')
bitcoin-cli decodescript "$witness" | jq -r '.p2sh'
