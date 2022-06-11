# Plataforma de ticket v0.0.7

# msg.sender = endereço de quem chamou a função
# msg.value = valor passado

# Dicionário que indica se o usuário comprou um ticket
# Se retornar 0, o usuário não possui ticket
users: public(HashMap[address, uint256])

# Valor do ingresso
price: uint256

# Endereço do dono do contrato
owner: address

# Número máximo de tickets
limit: uint256

# Número de tickets emitidos
count: uint256

# Variável de cancelamento
end: uint256

# Função que roda quando é feito o deploy do contrato
@external
def __init__(price: uint256, limit: uint256):
    # Guarda o Endereço do dono do contrato na variável
    self.owner = msg.sender
    self.price = price
    self.limit = limit
    self.count = 0
    self.end = 0

@external # Habilita para interação externa (função chamável)
@payable # Habilita o recebimento de valores pela função
def buy():
    # Testa se o comprador já não comprou
    assert self.users[msg.sender] == 0
    
    # Testa se o valor passado ao contrato foi suficiente
    assert msg.value >= self.price
    
    # Testa se ainda há tickets sobrando
    assert self.count <= self.limit
    
    # Preenche o dicionário com 1 no endereço de quem chamou a função
    # msg.sender existe para toda função e não precisa entrar como argumento
    self.users[msg.sender] = 1
    
    self.count += 1 # Soma 1 se finalizar a compra

    assert self.end == 0
    
@external
def change_price(price: uint256):
    # Testa se é o dono do contrato
    assert msg.sender == self.owner
    
    # Altera o preço
    self.price = price

# A função não precisa ser payable
@external
def cancel():
    # Testa se o comprador já comprou
    assert self.users[msg.sender] == 1
    
    # Anula a compra
    self.users[msg.sender] = 0

    # Subtrai 1 do contador de ingressos
    self.count -= 1

    # Garante que o evento não acabou
    assert self.end == 0

    # Devolve 80% do dinheiro (todos os valores tem que ser inteiros)
    send(msg.sender, self.price*80/100)
    
# Exercício 5
@external
def tranfer(receiver: address): 
    # Testa se o comprador já comprou
    assert self.users[msg.sender] == 1

    # Testa se o endereço de destino não possui ingresso
    assert self.users[receiver] == 0

    # Garante que o evento não acabou
    assert self.end == 0

    # Muda o Ownership no dicionário
    self.users[msg.sender] = 0
    self.users[receiver] == 1

# Exercício 6
@external
def end_event():
    # Testa se é o dono do contrato
    assert msg.sender == self.owner

    # Sinalizar que acabou o evento por meio de uma variavel
    self.end = 1

    # Manda o dinheiro para o dono no contrato
    send(self.owner, self.balance)
