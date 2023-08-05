/*-----------------------------------------------------------------
Banco: FastBank
Autor: Ralfe
�ltima altera��o: 17/04/2023 �s 19:00
Descri��o: Exerc�cios de consultas que geram novas colunas
------------------------------------------------------------------*/

-- Conex�o com o Banco
USE Fastbank
GO

-- Consultas que geram novas colunas

-- 01. Consulte quantos contatos cada cliente possui 

	SELECT Cli.nome_razaoSocial,
		   COUNT(Con.numero) AS 'Telefones',
		   COUNT(Con.email) AS 'E-mails'
	FROM Cliente AS Cli
	LEFT JOIN Contato AS Con ON Cli.codigo = Con.codigoCliente
	GROUP BY Cli.nome_razaoSocial


-- 02. Consulte o total movimentado em cada opera��o (d�bito, cr�dito ou transfer�ncia) no dia 04/02/2023

	-- Todos as movimenta��es
	SELECT Mov.operacao,
	       Mov.valor AS '04/02/2023' 
	FROM Movimentacao AS Mov
	WHERE CAST(Mov.dataHora AS DATE) = '04/02/2023'
	ORDER BY Mov.operacao


	-- Movimenta��es agrupadas
	SELECT Mov.operacao,
	       SUM(Mov.valor) AS '04/02/2023' 
	FROM Movimentacao AS Mov
	WHERE CAST(Mov.dataHora AS DATE) = '04/02/2023'
	GROUP BY Mov.operacao


-- 03. Consulte o menor, o maior e a m�dia dos valores sacados (d�bitos) no dia 05/02/2023

	SELECT -- Mov.operacao,
	       MIN(Mov.valor) AS 'Menor saque',
		   MAX(Mov.valor) AS 'Maior saque',
		   AVG(Mov.valor) AS 'M�dia de saques'
	FROM Movimentacao AS Mov
	WHERE Mov.operacao = 'debito' AND CAST(Mov.dataHora AS DATE) = '05/02/2023'
	-- GROUP BY Mov.operacao


-- 04. Consulte o valor que ser� pago de taxa de administra��o (porcentagem sobre a rentabilidade) e a rentabilidade final 
--     (descontando a taxa de adminstra��o) dos investimentos em CDB


	SELECT I.tipo,
	       I.aporte,
		   I.rentabilidade,
		   I.rentabilidade * I.taxaAdministracao AS 'Taxa de administra��o',
		   I.rentabilidade - (I.rentabilidade * I.taxaAdministracao) AS 'Rentabilidade final'
	FROM Investimento AS I
	WHERE I.tipo = 'CDB'


