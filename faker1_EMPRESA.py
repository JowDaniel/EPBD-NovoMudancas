# -*- coding: utf-8 -*-

from faker import Faker
import pg8000

# Conectar ao banco
conn = pg8000.connect(database="NovoMudancas", user="postgres", password="314159", host="localhost", port=5432)
cursor = conn.cursor()

# Lista de cidades principais (pré-definidas)
cidades = [
    ("Sao Paulo", "SP"),
    ("Rio de Janeiro", "RJ"),
    ("Belo Horizonte", "MG")
]

# Inserir cidades na tabela 'cidade' se ainda não existirem
for cidade in cidades:
    cursor.execute(
        """
        INSERT INTO public.cidade (nome, estado)
        VALUES (%s, %s)
        ON CONFLICT (nome) DO NOTHING
        """,
        cidade
    )

# Recuperar o maior valor de 'id' existente na tabela 'empresa'
cursor.execute("SELECT COALESCE(MAX(id), 0) FROM public.empresa;")
max_id = cursor.fetchone()[0]

# Gerar dados fictícios
faker = Faker('pt_BR')
empresas = [
    ("Mudancas XYZ", "Av Principal 456", "Sao Paulo"),
    ("Mudancas ABC", "Rua Secundaria 789", "Rio de Janeiro")
]

# Adicionar mais dados fictícios
for i in range(1, 9):  # Gerar mais 8 registros para totalizar 10
    nome = f"Mudancas {faker.company_suffix()}"
    endereco = f"Rua {faker.word()} {faker.random_int(100, 999)}"
    nomecidade = faker.random_element(["Sao Paulo", "Rio de Janeiro", "Belo Horizonte"])  # Seleciona cidades existentes
    empresas.append((nome, endereco, nomecidade))

# Inserir os dados no banco usando ON CONFLICT para evitar duplicados
for idx, empresa in enumerate(empresas, start=max_id + 1):
    cursor.execute(
        """
        INSERT INTO public.empresa (id, nome, endereco, nomecidade)
        VALUES (%s, %s, %s, %s)
        ON CONFLICT (id) DO NOTHING
        """,
        (idx, *empresa)
    )

# Confirmar e fechar conexão
conn.commit()
cursor.close()
conn.close()

print("Cidades e Empresas inseridas com sucesso!")
