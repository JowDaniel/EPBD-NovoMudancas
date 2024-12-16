# -*- coding: utf-8 -*-

from faker import Faker
import pg8000
from random import randint, uniform

# Conectar ao banco
conn = pg8000.connect(database="NovoMudancas", user="postgres", password="314159", host="localhost", port=5432)
cursor = conn.cursor()

# Recuperar IDs válidos de tipos de serviço existentes
cursor.execute("SELECT id_tipo FROM public.tiposervico;")
ids_tipo = [row[0] for row in cursor.fetchall()]

if not ids_tipo:
    raise Exception("Nenhum tipo de servico existente na tabela 'tiposervico'. Insira registros antes de continuar.")

# Gerar dados fictícios para a tabela 'servicos'
faker = Faker('pt_BR')
servicos = []

for i in range(1, 11):  # Gerar 10 registros
    nome = f"Servico {i} - {faker.word().capitalize()}"
    tempodurac = randint(1, 48)  # Tempo de duração entre 1 e 48 horas
    preco = round(uniform(100, 10000), 2)  # Preço entre 100 e 10.000
    id_tipo = faker.random_element(ids_tipo)  # Seleciona um id_tipo válido
    servicos.append((nome, tempodurac, preco, id_tipo))

# Inserir os dados no banco usando ON CONFLICT para evitar duplicados
cursor.executemany(
    """
    INSERT INTO public.servicos (nome, tempodurac, preco, id_tipo)
    VALUES (%s, %s, %s, %s)
    ON CONFLICT (nome) DO NOTHING
    """,
    servicos
)

# Confirmar e fechar conexão
conn.commit()
cursor.close()
conn.close()

print("Servicos inseridos com sucesso!")
