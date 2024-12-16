# -*- coding: utf-8 -*-

from faker import Faker
import pg8000
from random import randint, uniform

# Conectar ao banco
conn = pg8000.connect(database="NovoMudancas", user="postgres", password="314159", host="localhost", port=5432)
cursor = conn.cursor()

# Recuperar IDs válidos de empresas existentes
cursor.execute("SELECT id FROM public.empresa;")
ids_empresa = [row[0] for row in cursor.fetchall()]

if not ids_empresa:
    raise Exception("Nenhuma empresa existente na tabela 'empresa'. Insira registros antes de continuar.")

# Recuperar o maior valor de 'id' existente em 'funcionario'
cursor.execute("SELECT COALESCE(MAX(id), 0) FROM public.funcionario;")
max_id = cursor.fetchone()[0]

# Lista de cargos
cargos = [
    "Motorista",
    "Gerente",
    "Assistente Administrativo",
    "Coordenador de Operacoes",
    "Analista de Logistica",
    "Assistente de Campo",
    "Coordenadora de Frota",
    "Supervisor de Transporte",
    "Analista Financeira"
]

# Gerar dados fictícios
faker = Faker('pt_BR')
funcionarios = []

for i in range(1, 31):  # Gerar 10 registros
    id_empresa = faker.random_element(ids_empresa)  # Seleciona um ID de empresa válido
    nome = faker.first_name()
    sobrenome = faker.last_name()
    cargo = faker.random_element(cargos)
    salario = round(uniform(2500, 5000), 2)  # Salário entre 2500 e 5000
    data_admissao = faker.date_between(start_date="-10y", end_date="today")
    funcionarios.append((max_id + i, id_empresa, nome, sobrenome, cargo, salario, data_admissao))

# Inserir os dados no banco
cursor.executemany(
    """
    INSERT INTO public.funcionario (id, id_empresa, nome, sobrenome, cargo, salario, data_admissao)
    VALUES (%s, %s, %s, %s, %s, %s, %s)
    ON CONFLICT (id) DO NOTHING
    """,
    funcionarios
)

# Confirmar e fechar conexão
conn.commit()
cursor.close()
conn.close()

print("Funcionarios inseridos com sucesso!")
