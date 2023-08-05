/*---------------------------------------------
Banco: FastBank
Autor: Ralfe
Última alteração: 03/05/2023 - 22:30 - Ralfe
Descrição: Tabelas temporárias
--------------------------------------------*/
/* Documentação:

	Tabela temporária
	Variável tipo tabela
	Tipo de Tabela Definida pelo Usuário
	https://learn.microsoft.com/pt-br/sql/relational-databases/in-memory-oltp/faster-temp-table-and-table-variable-by-using-memory-optimization
	Obs.: Exemplos de Tipo de Tabela Definida pelo Usuário no banco Livraria

	Banco de Dados tempdb
	https://learn.microsoft.com/pt-br/sql/relational-databases/databases/tempdb-database

*/


-- Conexão com o Banco
USE Fastbank
GO


--------------------------------------------------------------------------------------
-- Tabelas temporárias de sessão #
-- Tabelas temporárias de global ##


-- Tabela temporária escopo de sessão
BEGIN
	-- Exclusão da tabela temporária caso já exista
	DROP TABLE IF EXISTS #TemporariaSessao

	-- Criação de tabela temporária (com escopo de sessão #)
	CREATE TABLE #TemporariaSessao(
		nome VARCHAR(100),
		idade INT
	)

	-- Inserção de valores na tabela temporária
	INSERT INTO #TemporariaSessao
	VALUES('Zé', 25),
		  ('Jão', 30),
		  ('Mané', 35)

	-- Verifica tabela 
	SELECT * FROM #TemporariaSessao

	-- Exclui a tabela temporária
	DROP TABLE IF EXISTS #TemporariaSessao
END
GO


-- Tabela temporária escopo de global
BEGIN
	-- Exclui a tabela temporária caso já exista
	DROP TABLE IF EXISTS ##TemporariaGlobal

	-- Cria a tabela temporária (com escopo global ##)
	CREATE TABLE ##TemporariaGlobal(
		nome VARCHAR(100),
		idade INT
	)

	-- Inserção de valores na tabela temporária
	INSERT INTO ##TemporariaGlobal
	VALUES('Maria', 22),
		  ('Joaquina', 32),
		  ('Ana', 37)

	-- Verifica tabela
	SELECT * FROM ##TemporariaGlobal

	-- Exclui a tabela temporária
	DROP TABLE IF EXISTS ##TemporariaGlobal
END
GO

---------------------------------------------------------------------------------------------
-- Criação de tabela temporária a partir de um SELECT
BEGIN
	-- Exclui a tabela temporária caso já exista
	DROP TABLE IF EXISTS #ClienteIdade

	-- Gera uma tabela temporária a partir da consulta
	SELECT Cli.nome_razaoSocial AS 'Nome',
		   DATEDIFF(YEAR, Cli.dataNascimento_abertura, GETDATE()) AS 'Idade'
	INTO #ClienteIdade
	FROM Cliente AS Cli
	INNER JOIN ClientePF AS PF ON Cli.codigo = PF.codigoCliente

	-- Altera o nome (na tabela temporária)
	UPDATE #ClienteIdade
	SET Nome = (SELECT SUBSTRING(Nome, 1, CHARINDEX(' ', Nome)) )
	FROM #ClienteIdade

	-- Filtra registros (da tabela temporária)
	SELECT * 
	FROM #ClienteIdade
	WHERE Idade >= 30
	ORDER BY Nome

	-- Exclui a tabela temporária
	DROP TABLE IF EXISTS #ClienteIdade
END
GO


-- Simulação de quitação de emprestimo

-- Calcular os valores para quitação de emprestimo com desconto 
-- Se o emprestimo tiver 3 ou mais parcelas pagas a quitação terá 10% desconto

BEGIN
	-- Exclui a tabela temporária caso já exista
	DROP TABLE IF EXISTS #Quitacao

	-- Declaração de variáveis
	DECLARE @CodigoCliente INT = 2,
	        @ParcelasPagas INT,
			@TotalPagar SMALLMONEY

	-- Consulta os emprestimos de um determinado cliente
	-- Armazenando o retorno em uma tabela temporária
	SELECT -- Cli.codigo,
	       Cli.nome_razaoSocial,
		   -- E.codigo,
		   E.valorSolicitado,
		   E.dataAprovacao,
		   -- E.aprovado,
		   E.numeroParcela,
		   Parcela.numero,
		   Parcela.valorParcela,
		   Parcela.valorPago
	INTO #Quitacao
	FROM Cliente AS Cli
	INNER JOIN ClienteConta AS CC ON Cli.codigo = CC.codigoCliente
	INNER JOIN Conta AS Con ON CC.codigoConta = Con.codigo
	INNER JOIN Emprestimo AS E ON Con.codigo = E.codigoConta
	INNER JOIN EmprestimoParcela AS Parcela ON E.codigo = Parcela.codigoEmprestimo
	WHERE E.aprovado = 1 AND Cli.codigo = @CodigoCliente

	-- Obtém a quantidade de regisros pagos
	SELECT @ParcelasPagas = COUNT(*) 
	FROM #Quitacao
	WHERE valorPago IS NOT NULL
	
	-- Exclui os regisros pagos
	DELETE FROM #Quitacao
	WHERE valorPago IS NOT NULL

	-- Se foram pagas mais de três parcelas
	IF(@ParcelasPagas > 3)
		BEGIN
			-- Apresenta os calculos de desconto
			SELECT SUM(valorParcela) AS 'Total',
			       (SUM(valorParcela) * 0.1) AS 'Desconto',
			       SUM(valorParcela) - (SUM(valorParcela) * 0.1) AS 'Total com desconto'
			FROM #Quitacao

			-- Apresenta as parcelas em aberto
			SELECT numero,
			       valorParcela
			FROM #Quitacao
		END
	ELSE
		BEGIN
			-- Apresenta o valor de quitação sem desconto
			SELECT SUM(valorParcela) AS 'Sem desconto', 
			       @ParcelasPagas AS 'Parcelas'
			FROM #Quitacao
		END

	-- Exclui a tabela temporária
	DROP TABLE IF EXISTS #Quitacao
END
GO



