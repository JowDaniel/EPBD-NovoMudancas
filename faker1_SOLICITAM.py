# -*- coding: utf-8 -*-

from faker import Faker
import pg8000
from random import randint, uniform

# Conectar ao banco
conn = pg8000.connect(database="NovoMudancas", user="postgres", password="314159", host="localhost", port=5432)
cursor = conn.cursor()

# Recuperar IDs válidos de referências
cursor.execute("SELECT nome FROM public.servicos;")
servicos = [row[0] for row in cursor.fetchall()]

cursor.execute("SELECT codigo FROM public.pedido;")
pedidos = [row[0] for row in cursor.fetchall()]

cursor.execute("SELECT cpf FROM public.clientes;")
cpfs = [row[0] for row in cursor.fetchall()]

cursor.execute("SELECT nome FROM public.cidade;")
cidades = [row[0] for row in cursor.fetchall()]

cursor.execute("SELECT id FROM public.empresa;")
empresas = [row[0] for row in cursor.fetchall()]

# Verificar se há dados suficientes para criar registros
if not (servicos and pedidos and cpfs and cidades and empresas):
    raise Exception("Certifique-se de que as tabelas servicos, pedido, clientes, cidade e empresa contenham registros validos.")

# Gerar dados fictícios
faker = Faker('pt_BR')
solicitacoes = []

for i in range(1, 350):  # Gerar 10 registros
    nome_servico = faker.random_element(servicos)
    codigo_pedido = faker.random_element(pedidos)
    cpf_cliente = faker.random_element(cpfs)
    tempohoradurac = randint(1, 48)  # Duração entre 1 e 48 horas
    preco = round(uniform(100, 5000), 2)  # Preço entre 100 e 5000
    datafim = faker.date_between(start_date="-1y", end_date="today")
    cidadeorigem = faker.random_element(cidades)
    cidadedestino = faker.random_element(cidades)
    id_empresa = faker.random_element(empresas)
    solicitacoes.append((nome_servico, codigo_pedido, cpf_cliente, tempohoradurac, preco, datafim, cidadeorigem, cidadedestino, id_empresa))

# Inserir os dados no banco usando ON CONFLICT para evitar duplicatas
cursor.executemany(
    """
    INSERT INTO public.solicitam (nome, codigo, cpf, tempohoradurac, preco, datafim, cidadeorigem, cidadedestino, id_empresa)
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
    ON CONFLICT (nome, codigo, cpf) DO NOTHING
    """,
    solicitacoes
)

# Confirmar e fechar conexão
conn.commit()
cursor.close()
conn.close()

print("Solicitacoes inseridas com sucesso!")
