# -*- coding: utf-8 -*-

from faker import Faker
import pg8000

# Conectar ao banco
conn = pg8000.connect(database="NovoMudancas", user="postgres", password="314159", host="localhost", port=5432)
cursor = conn.cursor()

# Recuperar o maior valor de 'codigo' existente
cursor.execute("SELECT COALESCE(MAX(codigo), 0) FROM Clientes;")
max_codigo = cursor.fetchone()[0]

# Gerar dados fictícios
faker = Faker('pt_BR')
clientes = []
for i in range(1, 110):  # Gerar 109 clientes
    cpf = faker.cpf().replace(".", "").replace("-", "")  # Remove caracteres especiais para CPF
    rg = faker.random_number(digits=9)  # Gera um RG com no máximo 9 dígitos
    clientes.append((max_codigo + i, cpf, rg, faker.name(), faker.address()))

# Inserir os dados no banco
cursor.executemany(
    "INSERT INTO Clientes (Codigo, CPF, RG, NomeCompl, Endereco) VALUES (%s, %s, %s, %s, %s)",
    clientes
)

# Confirmar e fechar conexão
conn.commit()
cursor.close()
conn.close()

print("Clientes inseridos com sucesso!")
