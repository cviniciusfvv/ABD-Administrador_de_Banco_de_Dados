/*------------------------------------------------------
Banco: FastBank
Autor: Ralfe
�ltima altera��o: 31/05/2023 - 22:45
Descri��o: Execu��o de Objetos de Banco de Dados
-------------------------------------------------------*/

USE FastBank
GO

----------------------------------------------------------------------------------------------
-- Stored Procedure

-- Bloco de instru��es para execu��o da SP
BEGIN 
	-- Declara��o de variav�l do tipo tabela
	DECLARE @DadosEmprestimo tpEmprestimo

	-- Inser��o de valores do novo emprestimo
	INSERT INTO @DadosEmprestimo
	VALUES(6, GETDATE(), 40000.00, 0.04, 1, 24, GETDATE(), 'Primeiro emprestimo')

	-- Chamada SP passando a vari�vel tabela como par�metro
	EXEC stpNovoEmprestimo @Emprestimo = @DadosEmprestimo
END
GO


-- Instru��es que ser�o executadas antes da chamada da stpContaInvestimentoPJ
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


	-- Chamada SP passando as vari�veis tabelas como par�metros
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



-- Bloco de instru��es para execu��o da SP
BEGIN 
	-- Declara��o de variav�l do tipo tabela
	DECLARE @DadosEmprestimo tpEmprestimo

	-- Inser��o de valores do novo emprestimo
	INSERT INTO @DadosEmprestimo
	VALUES(3, GETDATE(), 35000.00, 0.03, 1, -5, GETDATE(), '')

	-- Chamada SP passando a vari�vel tabela como par�metro
	EXEC stpNovoEmprestimo @Emprestimo = @DadosEmprestimo
END
GO

-- Verifica o resultado
SELECT * 
FROM Emprestimo AS E
LEFT JOIN EmprestimoParcela AS Parcelas ON E.codigo = Parcelas.codigoEmprestimo
GO



-- Instru��es que ser�o executadas antes da chamada da stpContaInvestimentoPJ
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


	-- Chamada da SP passando as vari�veis tabelas como par�metros
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
