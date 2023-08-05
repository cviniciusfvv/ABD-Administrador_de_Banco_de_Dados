/*------------------------------------------------------
Banco: FastBank
Autor: Ralfe
Última alteração: 31/05/2023 - 22:45
Descrição: Execução de Objetos de Banco de Dados
-------------------------------------------------------*/

USE FastBank
GO

----------------------------------------------------------------------------------------------
-- Stored Procedure

-- Bloco de instruções para execução da SP
BEGIN 
	-- Declaração de variavél do tipo tabela
	DECLARE @DadosEmprestimo tpEmprestimo

	-- Inserção de valores do novo emprestimo
	INSERT INTO @DadosEmprestimo
	VALUES(6, GETDATE(), 40000.00, 0.04, 1, 24, GETDATE(), 'Primeiro emprestimo')

	-- Chamada SP passando a variável tabela como parâmetro
	EXEC stpNovoEmprestimo @Emprestimo = @DadosEmprestimo
END
GO


-- Instruções que serão executadas antes da chamada da stpContaInvestimentoPJ
BEGIN
	DECLARE	@ValoresConta tpConta,
			@ValoresCartao tpCartao,
			@ValoresInvestimento tpInvestimento

	INSERT INTO @ValoresConta
	VALUES('02582', '2277380', 'investimento', 0, 1)

	INSERT INTO @ValoresCartao
	VALUES('2702581341239873', '478', '01/05/2025', 'MasterCard', 'bloqueado')

	INSERT INTO @ValoresInvestimento
	VALUES('acoes', 10000.00, 0, 'curto', 'AA', 0, 0)


	-- Chamada SP passando as variáveis tabelas como parâmetros
	EXEC stpContaInvestimentoPJ @Conta = @ValoresConta,
						        @Cartao = @ValoresCartao,
								@Investimento = @ValoresInvestimento

	SELECT * 
	FROM Conta
	INNER JOIN Cartao ON Conta.codigo = Cartao.codigoConta
	INNER JOIN Investimento ON Conta.codigo = Investimento.codigoConta
	WHERE Conta.codigo = (SELECT MAX(codigo) FROM Conta)

END
GO



-- Bloco de instruções para execução da SP
BEGIN 
	-- Declaração de variavél do tipo tabela
	DECLARE @DadosEmprestimo tpEmprestimo

	-- Inserção de valores do novo emprestimo
	INSERT INTO @DadosEmprestimo
	VALUES(3, GETDATE(), 35000.00, 0.03, 1, -5, GETDATE(), '')

	-- Chamada SP passando a variável tabela como parâmetro
	EXEC stpNovoEmprestimo @Emprestimo = @DadosEmprestimo
END
GO

-- Verifica o resultado
SELECT * 
FROM Emprestimo AS E
LEFT JOIN EmprestimoParcela AS Parcelas ON E.codigo = Parcelas.codigoEmprestimo
GO



-- Instruções que serão executadas antes da chamada da stpContaInvestimentoPJ
BEGIN
	DECLARE	@ValoresConta tpConta,
			@ValoresCartao tpCartao,
			@ValoresInvestimento tpInvestimento

	INSERT INTO @ValoresConta
	VALUES('02582', '2277380', 'investimento', 0, 1)

	INSERT INTO @ValoresCartao
	VALUES('2702581341239880', '478', '01/05/2025', 'MasterCard', 'bloqueado')

	INSERT INTO @ValoresInvestimento
	VALUES('acoes', 10000.00, 0, 'curto', 'AA', 0, 0)


	-- Chamada da SP passando as variáveis tabelas como parâmetros
	EXEC stpContaInvestimentoPJ @Conta = @ValoresConta,
						        @Cartao = @ValoresCartao,
								@Investimento = @ValoresInvestimento

	SELECT * 
	FROM Conta
	INNER JOIN Cartao ON Conta.codigo = Cartao.codigoConta
	INNER JOIN Investimento ON Conta.codigo = Investimento.codigoConta
	WHERE Conta.codigo = (SELECT MAX(codigo) FROM Conta)

END
GO
