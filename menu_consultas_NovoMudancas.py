# -*- coding: utf-8 -*-

import pg8000

# Configuracao do Banco de Dados
def conectar_banco():
    try:
        conn = pg8000.connect(
            database="NovoMudancas",
            user="postgres",
            password="314159",  # Altere para a sua senha
            host="localhost",
            port=5432
        )
        return conn
    except Exception as e:
        print(f"Erro ao conectar ao banco de dados: {e}")
        return None

# Consultas SQL
def consulta_servicos_cliente(conn):
    cliente_nome = input("Digite o nome do cliente: ")
    query = f"""
    SELECT c.nomecompl AS NomeCliente, s.nome AS NomeServico, ts.descricao AS TipoServico, s.datafim AS DataSolicitacao
    FROM Solicitam s
    JOIN Clientes c ON s.cpf = c.cpf
    JOIN Servicos sv ON s.nome = sv.nome
    JOIN TipoServico ts ON sv.id_tipo = ts.id_tipo
    WHERE c.nomecompl = '{cliente_nome}'
      AND s.datafim >= CURRENT_DATE - INTERVAL '1 month'
    ORDER BY s.datafim DESC;
    """
    executar_consulta(conn, query, "Servicos solicitados pelo cliente no ultimo mes")

def consulta_empresa_mais_ofereceu_servicos(conn):
    cidade = input("Digite o nome da cidade: ")
    estado = input("Digite o estado: ")
    query = f"""
    SELECT e.nome AS Empresa, COUNT(s.codigo) AS TotalServicos, c.nome AS Cidade, c.estado AS Estado
    FROM Solicitam s
    JOIN Empresa e ON s.id_empresa = e.id
    JOIN Cidade c ON s.cidadeorigem = c.nome
    WHERE c.nome = '{cidade}' AND c.estado = '{estado}'
    GROUP BY e.nome, c.nome, c.estado
    ORDER BY TotalServicos DESC
    LIMIT 1;
    """
    executar_consulta(conn, query, "Empresa que mais ofereceu servicos a cidade")

def consulta_funcionarios_cliente(conn):
    cliente_nome = input("Digite o nome do cliente: ")
    mes = int(input("Digite o numero do mes: "))
    ano = int(input("Digite o ano: "))
    query = f"""
    SELECT c.nomecompl AS Cliente, f.nome AS FuncionarioNome, f.sobrenome AS FuncionarioSobrenome
    FROM Solicitam s
    JOIN Clientes c ON s.cpf = c.cpf
    JOIN Funcionario f ON f.id_empresa = s.id_empresa
    WHERE c.nomecompl = '{cliente_nome}'
      AND EXTRACT(MONTH FROM s.datafim) = {mes}
      AND EXTRACT(YEAR FROM s.datafim) = {ano};
    """
    executar_consulta(conn, query, "Funcionarios que trabalharam para o cliente no periodo especificado")

def consulta_solicitacoes_ultimo_ano(conn):
    query = """
    SELECT c.nomecompl AS NomeCliente, s.nome AS NomeServico, s.cidadeorigem AS CidadeOrigem,
           COALESCE(s.cidadedestino, 'Nao Informada') AS CidadeDestino, s.preco AS PrecoTotal
    FROM Solicitam s
    JOIN Clientes c ON s.cpf = c.cpf
    WHERE s.datafim >= CURRENT_DATE - INTERVAL '1 year'
    ORDER BY s.datafim DESC;
    """
    executar_consulta(conn, query, "Solicitacoes feitas no ultimo ano")

def consulta_faturamento_mensal(conn):
    ano = int(input("Digite o ano desejado: "))
    mes = input("Digite o mes desejado (1-12) ou pressione Enter para visualizar todos os meses: ")

    # Adicionar filtro de mês, se informado
    filtro_mes = f"AND EXTRACT(MONTH FROM s.datafim) = {mes}" if mes.strip() else ""

    query = f"""
    SELECT e.nome AS Empresa, EXTRACT(MONTH FROM s.datafim) AS Mes, SUM(s.preco) AS Faturamento
    FROM Solicitam s
    JOIN Empresa e ON s.id_empresa = e.id
    WHERE EXTRACT(YEAR FROM s.datafim) = {ano} {filtro_mes}
    GROUP BY e.nome, EXTRACT(MONTH FROM s.datafim)
    ORDER BY e.nome, Mes;
    """
    executar_consulta(conn, query, "Faturamento das empresas por mes no ano especificado")


def consulta_servico_mais_solicitado(conn):
    mes = int(input("Digite o numero do mes: "))
    ano = int(input("Digite o ano: "))
    query = f"""
    SELECT s.nome AS Servico, COUNT(s.nome) AS QuantidadeSolicitacoes
    FROM Solicitam s
    WHERE EXTRACT(MONTH FROM s.datafim) = {mes} AND EXTRACT(YEAR FROM s.datafim) = {ano}
    GROUP BY s.nome
    ORDER BY QuantidadeSolicitacoes DESC
    LIMIT 1;
    """
    executar_consulta(conn, query, "Servico mais solicitado no periodo especificado")

def consulta_servico_mais_solicitado_por_empresa(conn):
    query = """
    WITH ServicoRanking AS (
        SELECT 
            e.nome AS Empresa,
            s.nome AS Servico,
            COUNT(s.nome) AS QuantidadeSolicitacoes,
            RANK() OVER (PARTITION BY e.nome ORDER BY COUNT(s.nome) DESC, s.nome ASC) AS Ranking
        FROM Solicitam s
        JOIN Empresa e ON s.id_empresa = e.id
        GROUP BY e.nome, s.nome
    )
    SELECT Empresa, Servico, QuantidadeSolicitacoes
    FROM ServicoRanking
    WHERE Ranking = 1
    ORDER BY Empresa;
    """
    executar_consulta(conn, query, "Servico mais solicitado e numero de solicitacoes por empresa")



def consulta_cidade_mais_solicitacoes(conn):
    query = """
    SELECT COALESCE(s.cidadeorigem, s.cidadedestino) AS Cidade, COUNT(*) AS TotalSolicitacoes
    FROM Solicitam s
    GROUP BY COALESCE(s.cidadeorigem, s.cidadedestino)
    ORDER BY TotalSolicitacoes DESC
    LIMIT 1;
    """
    executar_consulta(conn, query, "Cidade com maior numero de solicitacoes")

def consulta_cidade_destino_mais_referenciada(conn):
    query = """
    SELECT s.cidadedestino AS CidadeDestino, COUNT(*) AS TotalPedidos
    FROM Solicitam s
    WHERE s.cidadedestino IS NOT NULL
    GROUP BY s.cidadedestino
    ORDER BY TotalPedidos DESC
    LIMIT 1;
    """
    executar_consulta(conn, query, "Cidade destino mais referenciada nos pedidos")

def consulta_faturamento_total_por_empresa(conn):
    query = """
    SELECT e.nome AS Empresa, SUM(s.preco) AS FaturamentoTotal
    FROM Solicitam s
    JOIN Empresa e ON s.id_empresa = e.id
    GROUP BY e.nome
    ORDER BY FaturamentoTotal DESC;
    """
    executar_consulta(conn, query, "Faturamento total por empresa")

# Funcao generica para executar consultas
def executar_consulta(conn, query, titulo):
    try:
        cursor = conn.cursor()
        cursor.execute(query)
        resultados = cursor.fetchall()
        colunas = [desc[0] for desc in cursor.description]

        print(f"\n--- {titulo} ---")
        print(" | ".join(colunas))
        for linha in resultados:
            print(" | ".join(map(str, linha)))

        cursor.close()
    except Exception as e:
        print(f"Erro ao executar a consulta: {e}")

# Menu principal
def menu_principal():
    conn = conectar_banco()
    if not conn:
        return

    while True:
        print("\n--- Menu de Consultas ---")
        print("1. Que tipo de servicos um determinado cliente X solicitou no ultimo mes.")
        print("2. Qual e a empresa que mais ofereceu servicos na cidade de origem Y.")
        print("3. Quais funcionarios trabalharam para o cliente X no mes Y do ano Z.")
        print("4. Listar as solicitacoes feitas no ultimo ano.")
        print("5. Listar o faturamento das empresas por mes em um ano.")
        print("6. Verificar o servico mais solicitado em um mes e ano.")
        print("7. Listar o servico mais solicitado e numero de solicitacoes por empresa.")
        print("8. Verificar em qual cidade houve o maior numero de solicitacoes.")
        print("9. Verificar qual a cidade destino mais referenciada nos pedidos.")
        print("10. Listar o faturamento total para cada empresa.")
        print("11. Sair")

        opcao = input("Escolha uma opcao: ")

        if opcao == '1':
            consulta_servicos_cliente(conn)
        elif opcao == '2':
            consulta_empresa_mais_ofereceu_servicos(conn)
        elif opcao == '3':
            consulta_funcionarios_cliente(conn)
        elif opcao == '4':
            consulta_solicitacoes_ultimo_ano(conn)
        elif opcao == '5':
            consulta_faturamento_mensal(conn)
        elif opcao == '6':
            consulta_servico_mais_solicitado(conn)
        elif opcao == '7':
            consulta_servico_mais_solicitado_por_empresa(conn)
        elif opcao == '8':
            consulta_cidade_mais_solicitacoes(conn)
        elif opcao == '9':
            consulta_cidade_destino_mais_referenciada(conn)
        elif opcao == '10':
            consulta_faturamento_total_por_empresa(conn)
        elif opcao == '11':
            print("Encerrando o programa.")
            break
        else:
            print("Opcao invalida. Tente novamente.")

    conn.close()

# Executa o menu principal
menu_principal()
