/*------------------------------------------------------
Banco: FastBank
Autor: Ralfe
�ltima altera��o: 31/05/2023 - 22:45
Descri��o: Execu��o de Objetos de Banco de Dados
-------------------------------------------------------*/

USE FastBank
GO


-- Views

-- Objeto de banco criado em Banco > Exibi��es\Views
SELECT * FROM vwClientesCartoes
GO


-- As altera��es nas tabelas permanentes s�o vis�veis/acess�veis na View
SELECT * FROM vwClientesCartoes
GO


----------------------------------------------------------------------------------------------------------
-- Fun��es UDF (User Defined Functions ou Fun��es Definidas pelo Usu�rio)


-- Chamada/Invocar a fun��o
SELECT dbo.fnCreditosDiario()
GO

-- Chamada/Invocar a fun��o
SELECT dbo.fnDebitosDiario()
GO


-- Chamada/Invocar a fun��o
SELECT dbo.fnClienteInvestimentoCDB(1)
GO


-- Chamada/Invocar a fun��o
SELECT dbo.fnDebitosPeriodo('02/02/2023','05/02/2023')
GO

--> Fun��es com Valor de Tabela


-- Chamada/Invocar a fun��o
SELECT * FROM dbo.fnMovimentacaoDiaria('04/02/2023')
GO


-- Chamada/Invocar a fun��o
SELECT dbo.fnConsultaClientePF('33698613999')
SELECT dbo.fnConsultaClientePF('33698613000')



-- Consulta totais diarios (fun��es como coluna)
SELECT dbo.fnCreditosDiario() AS 'Creditos',
       dbo.fnDebitosDiario() AS 'Debitos',
	   AVG(valor) AS 'M�dia'
FROM Movimentacao


----------------------------------------------------------------------------------------------
-- Stored Procedure

-- Chamada/Execu��o da SP
EXEC stpMovimentacaoConta @Conta = 3
GO


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



-- Instru��es que ser�o executadas antes da chamada da stpNovoCliente
BEGIN
	DECLARE	@ValoresEndereco tpEndereco,
			@ValoresClientePF tpClientePF,
			@ValoresContato tpContato,
			@ValoresConta tpConta,
			@ValoresCartao tpCartao

	INSERT INTO @ValoresEndereco
	VALUES('Avenida Boa Vista', 'Parque S�o Francisco', 'Teresina', 'PI', '30773-033')

	INSERT INTO @ValoresClientePF
	VALUES('Patricia Lima Campos', NULL, '', '28/04/1993', 'patricia', 898, '96065476048', 'PI-42.859.952')

	INSERT INTO @ValoresContato
	VALUES('(86) 84358-2497', NULL, 'patricia@yahoo.com', 'Hor�rio comercial')

	INSERT INTO @ValoresConta
	VALUES('02582', '2255614', 'corrente', 2500.00, 1)

	INSERT INTO @ValoresCartao
	VALUES('3706261345869180', '656', '01/05/2025', 'Visa', 'bloqueado')

	-- Chamada SP passando as vari�veis tabelas como par�metros
	EXEC stpNovoCliente @Endereco = @ValoresEndereco,
						@ClientePF = @ValoresClientePF,
						@Contato = @ValoresContato,
						@Conta = @ValoresConta,
						@Cartao = @ValoresCartao


	-- Verifica��o do resultado
	SELECT *
	FROM Cliente AS Cli
	INNER JOIN Endereco AS E ON Cli.codigoEndereco = E.codigo
	INNER JOIN ClientePF AS PF ON Cli.codigo = PF.codigoCliente
	INNER JOIN Contato AS C ON Cli.codigo = C.codigoCliente
	INNER JOIN ClienteConta AS CC ON Cli.codigo = CC.codigoCliente
	INNER JOIN Conta AS Con ON CC.codigoConta = Con.codigo
	INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta
	WHERE Cli.codigo = (SELECT MAX(codigo) FROM Cliente)

END
GO



-- Instru��es que ser�o executadas antes da chamada da stpTotalQuitacaoEmprestimo
BEGIN
	DECLARE @Retorno SMALLMONEY

	-- Chamada SP passando o c�digo do emprestimo como par�metro "de entrada"
	-- e armazenando o "retorno" (par�metro de sa�da)
	EXECUTE stpTotalQuitacaoEmprestimo @CodEmprestimo = 1,
									   @Valor = @Retorno OUTPUT

	SELECT FORMAT(@Retorno, 'C', 'pt-br') AS 'Valor quita��o'

	PRINT 'Valor total para quita��o: ' + FORMAT(@Retorno, 'C', 'pt-br')
END
GO



-- Instru��es que ser�o executadas antes da chamada da stpParcelasQuitacaoEmprestimo
BEGIN
	DECLARE @Retorno tpParcelasEmprestimo

	-- Insere o resultado da SP na vari�vel do tipo tabela
	INSERT INTO @Retorno
	EXECUTE stpParcelasQuitacaoEmprestimo @CodEmprestimo = 1

	SELECT * FROM @Retorno
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
