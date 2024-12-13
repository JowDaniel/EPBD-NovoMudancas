-- Consulta 1: Que tipo de servi�os um determinado cliente X solicitou no �ltimo m�s
SELECT 
    c.nomecompl AS NomeCliente,
    s.nome AS NomeServico,
    ts.descricao AS TipoServico,
    s.datafim AS DataSolicitacao
FROM Solicitam s
JOIN Clientes c ON s.cpf = c.cpf
JOIN Servicos sv ON s.nome = sv.nome
JOIN TipoServico ts ON sv.id_tipo = ts.id_tipo
WHERE c.nomecompl = 'Nome do Cliente' -- Substitua pelo nome do cliente desejado
  AND s.datafim >= CURRENT_DATE - INTERVAL '1 month'
ORDER BY s.datafim DESC;

-- Consulta 2: Qual � a empresa que mais ofereceu mais servi�os � cidade de Y no estado de Z
SELECT 
    e.nome AS Empresa,
    COUNT(s.codigo) AS TotalServicos,
    c.nome AS Cidade,
    c.estado AS Estado
FROM Solicitam s
JOIN Empresa e ON s.id_empresa = e.id
JOIN Cidade c ON s.cidadeorigem = c.nome
WHERE c.nome = 'Nome da Cidade' -- Substitua pela cidade desejada
  AND c.estado = 'Estado' -- Substitua pelo estado desejado
GROUP BY e.nome, c.nome, c.estado
ORDER BY TotalServicos DESC
LIMIT 1;

-- Consulta 3: Quais funcion�rios (nome e sobrenome) trabalharam para o cliente X no m�s Y do ano Z
SELECT 
    c.nomecompl AS Cliente,
    f.nome AS FuncionarioNome,
    f.sobrenome AS FuncionarioSobrenome
FROM Solicitam s
JOIN Clientes c ON s.cpf = c.cpf
JOIN Funcionario f ON f.id_empresa = s.id_empresa
WHERE c.nomecompl = 'Nome do Cliente' -- Substitua pelo nome do cliente desejado
  AND EXTRACT(MONTH FROM s.datafim) = 7 -- Substitua pelo m�s desejado
  AND EXTRACT(YEAR FROM s.datafim) = 2024; -- Substitua pelo ano desejado

-- Consulta 4: Listar as solicita��es feitas no �ltimo ano, nome do cliente que as realizou, munic�pios de origem e destino (se houver) e pre�o total de cada solicita��o
SELECT 
    c.nomecompl AS NomeCliente,
    s.nome AS NomeServico,
    s.cidadeorigem AS CidadeOrigem,
    COALESCE(s.cidadedestino, 'N�o Informada') AS CidadeDestino,
    s.preco AS PrecoTotal
FROM Solicitam s
JOIN Clientes c ON s.cpf = c.cpf
WHERE s.datafim >= CURRENT_DATE - INTERVAL '1 year'
ORDER BY s.datafim DESC;

-- Consulta 5: para listar o faturamento das empresas por m�s em um ano X
SELECT 
    e.nome AS Empresa,
    EXTRACT(MONTH FROM s.datafim) AS Mes,
    SUM(s.preco) AS Faturamento
FROM 
    Solicitam s
JOIN 
    Empresa e ON s.id_empresa = e.id
WHERE 
    EXTRACT(YEAR FROM s.datafim) = 2024 -- Substitua 2024 pelo ano desejado
GROUP BY 
    e.nome, EXTRACT(MONTH FROM s.datafim)
ORDER BY 
    e.nome, Mes;

-- Consulta 6: para verificar o servi�o mais solicitado em um m�s e ano espec�ficos
SELECT 
    s.nome AS Servico,
    COUNT(s.nome) AS QuantidadeSolicitacoes
FROM 
    Solicitam s
WHERE 
    EXTRACT(MONTH FROM s.datafim) = 7 -- Substitua pelo m�s desejado
    AND EXTRACT(YEAR FROM s.datafim) = 2024 -- Substitua pelo ano desejado
GROUP BY 
    s.nome
ORDER BY 
    QuantidadeSolicitacoes DESC
LIMIT 1;

-- Consulta 7:  para listar o servi�o mais solicitado e o n�mero de solicita��es para cada empresa
SELECT 
    e.nome AS Empresa,
    s.nome AS Servico,
    COUNT(s.nome) AS QuantidadeSolicitacoes
FROM 
    Solicitam s
JOIN 
    Empresa e ON s.id_empresa = e.id
GROUP BY 
    e.nome, s.nome
ORDER BY 
    e.nome, QuantidadeSolicitacoes DESC;

-- Consulta 8: para verificar em qual cidade houve o maior n�mero de solicita��es
SELECT 
    COALESCE(s.cidadeorigem, s.cidadedestino) AS Cidade,
    COUNT(*) AS TotalSolicitacoes
FROM 
    Solicitam s
GROUP BY 
    COALESCE(s.cidadeorigem, s.cidadedestino)
ORDER BY 
    TotalSolicitacoes DESC
LIMIT 1;

-- Consulta 9: para verificar qual a cidade destino mais referenciada nos pedidos e sua quantidade
SELECT 
    s.cidadedestino AS CidadeDestino,
    COUNT(*) AS TotalPedidos
FROM 
    Solicitam s
WHERE 
    s.cidadedestino IS NOT NULL
GROUP BY 
    s.cidadedestino
ORDER BY 
    TotalPedidos DESC
LIMIT 1;
 
-- Consulta 10: para listar o faturamento total de cada empresa
SELECT 
    e.nome AS Empresa,
    SUM(s.preco) AS FaturamentoTotal
FROM 
    Solicitam s
JOIN 
    Empresa e ON s.id_empresa = e.id
GROUP BY 
    e.nome
ORDER BY 
    FaturamentoTotal DESC;