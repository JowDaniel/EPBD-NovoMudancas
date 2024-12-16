# -*- coding: utf-8 -*-

from faker import Faker
import pg8000

# Conectar ao banco
conn = pg8000.connect(database="NovoMudancas", user="postgres", password="314159", host="localhost", port=5432)
cursor = conn.cursor()

# Recuperar o maior valor de 'id_tipo' existente
cursor.execute("SELECT COALESCE(MAX(id_tipo), 0) FROM public.tiposervico;")
max_id_tipo = cursor.fetchone()[0]

# Lista de descrições de tipos de serviço
descricoes = [
    "Mudanca Residencial",
    "Mudanca Comercial",
    "Transporte de Carga",
    "Guindaste",
    "Armazenamento Temporario",
    "Embalagem e Transporte",
    "Transporte Especial",
    "Servico de Logistica",
    "Recolhimento de Materiais",
    "Despacho e Entrega"
]

# Gerar dados fictícios
faker = Faker('pt_BR')
tipos_servico = []

for i, descricao in enumerate(descricoes, start=1):
    tipos_servico.append((max_id_tipo + i, descricao))

# Inserir os dados no banco usando ON CONFLICT para evitar duplicados
cursor.executemany(
    """
    INSERT INTO public.tiposervico (id_tipo, descricao)
    VALUES (%s, %s)
    ON CONFLICT (id_tipo) DO NOTHING
    """,
    tipos_servico
)

# Confirmar e fechar conexão
conn.commit()
cursor.close()
conn.close()

print("Tipos de servico inseridos com sucesso!")
