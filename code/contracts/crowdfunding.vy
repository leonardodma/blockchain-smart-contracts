# @version ^0.2.2
# Plataforma de Crowdfunding v0.0.1

struct Contributor:
    value : uint256

contributors: public(HashMap[address, Contributor])

owner: address
goal: public(uint256)
deadline: public(uint256)

# Initial
@external
def __init__(goal: uint256, deadline: uint256):
    self.owner = msg.sender
    self.deadline = block.timestamp + deadline
    self.goal = goal


@external
@payable
def donate():
    # Verifica se o tempo pra doação ainda não acabou
    assert block.timestamp < self.deadline

    # Aumenta a doação do contribuidor
    self.contributors[msg.sender].value += msg.value


@external
def end():
    # Verifica se o tempo pra doação já acabou
    assert block.timestamp >= self.deadline

    # Verifica se a quantidade arrecadada foi o suficiente para o objetivo
    assert self.balance >= self.goal

    # Manda o dinheiro para o beneficiário
    send(self.owner, self.balance)


@external
def withdraw():
    # Verifica se o tempo pra doação já acabou
    assert block.timestamp >= self.deadline

    # Verifica se a quantidade arrecadada não foi o suficiente para o objetivo
    assert self.balance < self.goal

    # Verifica se o doador possui dinheiro na arrecadação
    assert self.contributors[msg.sender].value > 0

    # Manda o valor pra conta de quem solicitou o dinheiro de volta
    send(msg.sender,  self.contributors[msg.sender].value)

    # Zera o valor desse contribuidor na arrecadação
    self.contributors[msg.sender].value = 0
