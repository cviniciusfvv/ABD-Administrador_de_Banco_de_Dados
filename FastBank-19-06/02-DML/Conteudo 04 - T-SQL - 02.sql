/*---------------------------------------------
Banco: FastBank
Autor: Ralfe
�ltima altera��o: 03/05/2023 - 22:30 - Ralfe
Descri��o: Tabelas tempor�rias
--------------------------------------------*/
/* Documenta��o:

	Tabela tempor�ria
	Vari�vel tipo tabela
	Tipo de Tabela Definida pelo Usu�rio
	https://learn.microsoft.com/pt-br/sql/relational-databases/in-memory-oltp/faster-temp-table-and-table-variable-by-using-memory-optimization
	Obs.: Exemplos de Tipo de Tabela Definida pelo Usu�rio no banco Livraria

	Banco de Dados tempdb
	https://learn.microsoft.com/pt-br/sql/relational-databases/databases/tempdb-database

*/


-- Conex�o com o Banco
USE Fastbank
GO


--------------------------------------------------------------------------------------
-- Tabelas tempor�rias de sess�o #
-- Tabelas tempor�rias de global ##


-- Tabela tempor�ria escopo de sess�o
BEGIN
	-- Exclus�o da tabela tempor�ria caso j� exista
	DROP TABLE IF EXISTS #TemporariaSessao

	-- Cria��o de tabela tempor�ria (com escopo de sess�o #)
	CREATE TABLE #TemporariaSessao(
		nome VARCHAR(100),
		idade INT
	)

	-- Inser��o de valores na tabela tempor�ria
	INSERT INTO #TemporariaSessao
	VALUES('Z�', 25),
		  ('J�o', 30),
		  ('Man�', 35)

	-- Verifica tabela 
	SELECT * FROM #TemporariaSessao

	-- Exclui a tabela tempor�ria
	DROP TABLE IF EXISTS #TemporariaSessao
END
GO


-- Tabela tempor�ria escopo de global
BEGIN
	-- Exclui a tabela tempor�ria caso j� exista
	DROP TABLE IF EXISTS ##TemporariaGlobal

	-- Cria a tabela tempor�ria (com escopo global ##)
	CREATE TABLE ##TemporariaGlobal(
		nome VARCHAR(100),
		idade INT
	)

	-- Inser��o de valores na tabela tempor�ria
	INSERT INTO ##TemporariaGlobal
	VALUES('Maria', 22),
		  ('Joaquina', 32),
		  ('Ana', 37)

	-- Verifica tabela
	SELECT * FROM ##TemporariaGlobal

	-- Exclui a tabela tempor�ria
	DROP TABLE IF EXISTS ##TemporariaGlobal
END
GO

---------------------------------------------------------------------------------------------
-- Cria��o de tabela tempor�ria a partir de um SELECT
BEGIN
	-- Exclui a tabela tempor�ria caso j� exista
	DROP TABLE IF EXISTS #ClienteIdade

	-- Gera uma tabela tempor�ria a partir da consulta
	SELECT Cli.nome_razaoSocial AS 'Nome',
		   DATEDIFF(YEAR, Cli.dataNascimento_abertura, GETDATE()) AS 'Idade'
	INTO #ClienteIdade
	FROM Cliente AS Cli
	INNER JOIN ClientePF AS PF ON Cli.codigo = PF.codigoCliente

	-- Altera o nome (na tabela tempor�ria)
	UPDATE #ClienteIdade
	SET Nome = (SELECT SUBSTRING(Nome, 1, CHARINDEX(' ', Nome)) )
	FROM #ClienteIdade

	-- Filtra registros (da tabela tempor�ria)
	SELECT * 
	FROM #ClienteIdade
	WHERE Idade >= 30
	ORDER BY Nome

	-- Exclui a tabela tempor�ria
	DROP TABLE IF EXISTS #ClienteIdade
END
GO


-- Simula��o de quita��o de emprestimo

-- Calcular os valores para quita��o de emprestimo com desconto 
-- Se o emprestimo tiver 3 ou mais parcelas pagas a quita��o ter� 10% desconto

BEGIN
	-- Exclui a tabela tempor�ria caso j� exista
	DROP TABLE IF EXISTS #Quitacao

	-- Declara��o de vari�veis
	DECLARE @CodigoCliente INT = 2,
	        @ParcelasPagas INT,
			@TotalPagar SMALLMONEY

	-- Consulta os emprestimos de um determinado cliente
	-- Armazenando o retorno em uma tabela tempor�ria
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

	-- Obt�m a quantidade de regisros pagos
	SELECT @ParcelasPagas = COUNT(*) 
	FROM #Quitacao
	WHERE valorPago IS NOT NULL
	
	-- Exclui os regisros pagos
	DELETE FROM #Quitacao
	WHERE valorPago IS NOT NULL

	-- Se foram pagas mais de tr�s parcelas
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
			-- Apresenta o valor de quita��o sem desconto
			SELECT SUM(valorParcela) AS 'Sem desconto', 
			       @ParcelasPagas AS 'Parcelas'
			FROM #Quitacao
		END

	-- Exclui a tabela tempor�ria
	DROP TABLE IF EXISTS #Quitacao
END
GO



