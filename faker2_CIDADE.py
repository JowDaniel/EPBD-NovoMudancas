# -*- coding: utf-8 -*-

from faker import Faker
import pg8000

# Conectar ao banco
conn = pg8000.connect(database="NovoMudancas", user="postgres", password="314159", host="localhost", port=5432)
cursor = conn.cursor()

# Recuperar o número de registros existentes
cursor.execute("SELECT COUNT(*) FROM public.cidade;")
num_registros = cursor.fetchone()[0]

# Gerar dados fictícios
faker = Faker('pt_BR')
cidades = [
    ("Belo Horizonte", "MG"),
    ("Rio de Janeiro", "RJ"),
    ("Sao Paulo", "SP")
]

# Adicionar mais dados fictícios
for _ in range(7):  # Para gerar 10 cidades no total
    nome = faker.city()
    estado = faker.state_abbr()
    cidades.append((nome, estado))

# Inserir os dados no banco usando ON CONFLICT para evitar duplicados
for cidade in cidades:
    cursor.execute(
        """
        INSERT INTO public.cidade (nome, estado)
        VALUES (%s, %s)
        ON CONFLICT (nome) DO NOTHING
        """,
        cidade
    )

# Confirmar e fechar conexão
conn.commit()
cursor.close()
conn.close()

print("Cidades inseridas com sucesso (sem duplicatas)!")
