# Crowd Funding v0.0.1

contributors: HashMap[address, uint256]
beneficiary: address
goal: public(uint256)
deadline: public(uint256)

# Initial
@external
def __init__(beneficiary: address, goal: uint256, deadline: uint256):
    self.beneficiary = beneficiary
    self.deadline = block.timestamp + deadline
    self.goal = goal


@external
@payable
def donate():
    # Verifica se o tempo pra doação ainda não acabou
    assert block.timestamp < self.deadline

    # Aumenta a doação do contribuidor
    self.contributors[msg.sender] += msg.value


@external
def end():
    # Verifica se o tempo pra doação já acabou
    assert block.timestamp >= self.deadline

    # Verifica se a quantidade arrecadada foi o suficiente para o objetivo
    assert self.balance >= self.goal

    # Manda o dinheiro para o beneficiário
    send(self.beneficiary, self.balance)


@external
def refund():
    # Verifica se o tempo pra doação já acabou
    assert block.timestamp >= self.deadline

    # Verifica se a quantidade arrecadada não foi o suficiente para o objetivo
    assert self.balance < self.goal

    # Verifica se o doador possui dinheiro na arrecadação
    assert self.contributors[msg.sender] > 0

    # Manda o valor pra conta de quem solicitou o dinheiro de volta
    send(msg.sender,  self.contributors[msg.sender])

    # Zera o valor desse contribuidor na arrecadação
    self.contributors[msg.sender] = 0
