# -*- coding: utf-8 -*-

from faker import Faker
import pg8000
from random import randint, uniform

# Conectar ao banco
conn = pg8000.connect(database="NovoMudancas", user="postgres", password="314159", host="localhost", port=5432)
cursor = conn.cursor()

# Recuperar IDs v�lidos de clientes existentes
cursor.execute("SELECT codigo FROM public.clientes;")
ids_clientes = [row[0] for row in cursor.fetchall()]

# Recuperar IDs v�lidos de empresas existentes
cursor.execute("SELECT id FROM public.empresa;")
ids_empresas = [row[0] for row in cursor.fetchall()]

# Verificar se h� dados v�lidos
if not ids_clientes:
    raise Exception("Nenhum cliente encontrado na tabela 'clientes'. Insira registros antes de continuar.")
if not ids_empresas:
    raise Exception("Nenhuma empresa encontrada na tabela 'empresa'. Insira registros antes de continuar.")

# Recuperar o maior valor de 'codigo' existente na tabela 'pedido'
cursor.execute("SELECT COALESCE(MAX(codigo), 0) FROM public.pedido;")
max_codigo = cursor.fetchone()[0]

# Gerar dados fict�cios para a tabela 'pedido'
faker = Faker('pt_BR')
pedidos = []

for i in range(1, 350):  # Gerar 10 registros
    id_cliente = faker.random_element(ids_clientes)  # Seleciona um id_cliente v�lido
    id_empresa = faker.random_element(ids_empresas)  # Seleciona um id_empresa v�lido
    precototal = round(uniform(500, 10000), 2)  # Pre�o total entre 500 e 10.000
    pedidos.append((max_codigo + i, id_cliente, precototal, id_empresa))

# Inserir os dados no banco usando ON CONFLICT para evitar duplicados
cursor.executemany(
    """
    INSERT INTO public.pedido (codigo, id_cliente, precototal, id_empresa)
    VALUES (%s, %s, %s, %s)
    ON CONFLICT (codigo) DO NOTHING
    """,
    pedidos
)

# Confirmar e fechar conex�o
conn.commit()
cursor.close()
conn.close()

print("Pedidos inseridos com sucesso!")
