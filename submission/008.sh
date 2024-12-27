# Which public key signed input 0 in this tx:
#   `e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163`
# expected: 025d524ac7ec6501d018d322334f142c7c11aa24b9cffec03161eca35a1e32a71f

# Explicação: A input é SegWit e a txwitness tem 3 elementos.
# Geralmente o primeiro é a assinatura e o segundo a pubkey e o próximo o `witness script`
# Decodificamos o witness script com o comando `decodescript`, que está representado abaixo:
# OP_IF <pubkey1> OP_ELSE 144 OP_CHECKSEQUENCEVERIFY OP_DROP <pubkey2> OP_ENDIF OP_CHECKSIG
# O elemento 2 da txwitness é o byte 0x01, que no IF do witness script é avaliado como TRUE.
# Logo a pubkey1 foi utilizada.

witness_script=$(bitcoin-cli getrawtransaction e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163 1 | jq -r '.vin[0].txinwitness[2]')
asm=$(bitcoin-cli decodescript $witness_script | jq -r '.asm')
echo "${asm:6:66}"
