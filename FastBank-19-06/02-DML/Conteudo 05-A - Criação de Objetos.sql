/*------------------------------------------------------
Banco: FastBank
Autor: Ralfe
�ltima altera��o: 07/06/2023 - 22:45
Descri��o: Cria��o de Objetos de Banco de Dados
-------------------------------------------------------*/
/* Documenta��o:
	
	Objetos de BD
	https://learn.microsoft.com/pt-br/sql/relational-databases/blob/filetable-ddl-functions-stored-procedures-and-views

	View
	https://learn.microsoft.com/pt-br/sql/relational-databases/views/views

	Function
	https://learn.microsoft.com/pt-br/sql/t-sql/statements/create-function-transact-sql

	Stored Procedure
	https://learn.microsoft.com/pt-br/sql/relational-databases/stored-procedures/stored-procedures-database-engine

	TRIGGER
	https://learn.microsoft.com/pt-br/sql/t-sql/statements/create-trigger-transact-sql?view=sql-server-ver16
*/


USE FastBank
GO


-- Views

-- Cria��o de uma View que d� acesso aos Clientes e suas respecivas Contas e Cart�es
-- apresentando o nome do cliente, a agencia e numero da conta e o numero, bandeira, validade e situacao do cart�o

-- Vis�o geral dos dados envolvidos
SELECT * FROM Cliente
SELECT * FROM ClientePF
SELECT * FROM Conta
SELECT * FROM Cartao

SELECT *
FROM Cliente AS Cli
INNER JOIN ClienteConta AS CC ON Cli.codigo = CC.codigoCliente
INNER JOIN Conta AS Con ON CC.codigoConta = Con.codigo
INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta

-- Filtros de atributos e registros desejados
SELECT Cli.nome_razaoSocial,
       Con.agencia,
	   Con.numero,
	   Car.numero,
	   Car.bandeira,
	   Car.validade,
	   Car.situacao
FROM Cliente AS Cli
INNER JOIN ClienteConta AS CC ON Cli.codigo = CC.codigoCliente
INNER JOIN ClientePF AS PF ON Cli.codigo = PF.codigoCliente
INNER JOIN Conta AS Con ON CC.codigoConta = Con.codigo
INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta
WHERE Con.ativa = 1
GO

-- Cria��o da View a partir do SELECT
CREATE VIEW vwClientesCartoes AS
SELECT Cli.nome_razaoSocial AS 'Nome',
       Con.agencia AS 'Agencia',
	   Con.numero AS 'Conta',
	   Car.numero AS 'Cartao',
	   Car.bandeira AS 'Bandeira',
	   Car.validade AS 'Validade',
	   Car.situacao AS 'Situacao'
FROM Cliente AS Cli
INNER JOIN ClienteConta AS CC ON Cli.codigo = CC.codigoCliente
INNER JOIN ClientePF AS PF ON Cli.codigo = PF.codigoCliente
INNER JOIN Conta AS Con ON CC.codigoConta = Con.codigo
INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta
WHERE Con.ativa = 1
GO



-- Script de inser��o de um novo cliente pessoa f�sica com uma nova conta

-- Vis�o geral dos dados envolvidos
SELECT * FROM Endereco
SELECT * FROM Cliente
SELECT * FROM ClientePF
SELECT * FROM Contato
SELECT * FROM ClienteConta
SELECT * FROM Conta
SELECT * FROM Cartao


BEGIN
	DECLARE -- Endereco
	        @CodigoEndereco INT,
	        @Logradouro VARCHAR(100) = 'Avenida Boa Vista', 
			@Bairro VARCHAR(75) = 'Parque S�o Francisco',
			@Cidade VARCHAR(75) = 'Teresina',
			@Uf CHAR(2) = 'PI',
			@Cep CHAR(10) = '30773-033',
			-- Cliente
			@CodigoCliente INT,			
			@NomeRazao VARCHAR(100) = 'Patricia Lima Campos',
			@NomeSocialFantasia VARCHAR(100) = NULL,
			@Foto VARCHAR(100) = '',
			@DataNascAbertura DATE = '28/04/1993',
			@Usuario CHAR(10) = 'patricia', 
			@Senha INT = 898,
			-- ClientePF
			@Cpf VARCHAR(15) = '96065476048', 			
			@Rg VARCHAR(15) = 'PI-42.859.952',
			-- Contato
			@NumeroTelefone VARCHAR(15) = '(86) 84358-2497', 
			@Ramal VARCHAR(25) = NULL,
			@Email VARCHAR(50) = 'patricia@yahoo.com',
			@Observacao VARCHAR(50) = 'Hor�rio comercial',
			-- Conta
			@CodigoConta INT,
			@Agencia VARCHAR(10) = '02582', 			
			@NumeroConta VARCHAR(25) = '2255614',
			@Tipo VARCHAR(20) = 'corrente',
			@Limite SMALLMONEY = 2500.00,
			@Ativa BIT = 1,
			-- Cartao 
			@NumeroCartao VARCHAR(30) = '3706261345869180', 			
			@Cvv CHAR(5) = '656',
			@Validade DATE = '01/05/2025',
			@Bandeira VARCHAR(20) = 'Visa', 
			@Situacao VARCHAR(20) = 'bloqueado'

	-- Inser��o do endere�o
	INSERT INTO Endereco
	VALUES(@Logradouro, @Bairro, @Cidade, @Uf, @Cep)
	-- Recupera��o do codigo gerado
	SELECT @CodigoEndereco = MAX(codigo) FROM Endereco


	-- Inser��o do Cliente (generaliza��o)
	INSERT INTO Cliente
	VALUES(@CodigoEndereco, @NomeRazao, @NomeSocialFantasia, @Foto, @DataNascAbertura, @Usuario, @Senha)
	-- Recupera��o do codigo gerado
	SELECT @CodigoCliente = MAX(codigo) FROM Cliente
	-- Altera��o do atributo foto_logo
	UPDATE Cliente
	SET foto_logo = CONCAT('\fotos\',@CodigoCliente,'.jpg')
	WHERE codigo = @CodigoCliente

	-- Inser��o do ClientePF (especializa��o)
	INSERT INTO ClientePF
	VALUES(@CodigoCliente, @Cpf, @Rg)

	-- Inser��o do Contato
	INSERT INTO Contato
	VALUES(@CodigoCliente, @NumeroTelefone, @Ramal, @Email, @Observacao)


	-- Inser��o da Conta
	INSERT INTO Conta
	VALUES(@Agencia, @NumeroConta, @Tipo, @Limite, @Ativa)
	-- Recupera��o do codigo gerado
	SELECT @CodigoConta = MAX(codigo) FROM Conta

	-- Relacionamento entre Cliente e Conta
	INSERT INTO ClienteConta
	VALUES(@CodigoCliente, @CodigoConta)

	-- Inser��o do Cart�o
	INSERT INTO Cartao
	VALUES(@CodigoConta, @NumeroCartao, @Cvv, @Validade, @Bandeira, @Situacao)


	-- Verifica��o do resultado
	SELECT *
	FROM Cliente AS Cli
	INNER JOIN Endereco AS E ON Cli.codigoEndereco = E.codigo
	INNER JOIN ClientePF AS PF ON Cli.codigo = PF.codigoCliente
	INNER JOIN Contato AS C ON Cli.codigo = C.codigoCliente
	INNER JOIN ClienteConta AS CC ON Cli.codigo = CC.codigoCliente
	INNER JOIN Conta AS Con ON CC.codigoConta = Con.codigo
	INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta
	WHERE Cli.codigo = @CodigoCliente

END
GO



-- Altera��o na View...
SELECT * 
FROM vwClientesCartoes
WHERE Nome = 'Patricia Lima Campos'

UPDATE vwClientesCartoes
SET Validade = '01/05/2026'
WHERE Nome = 'Patricia Lima Campos'


-- Altera tamb�m as tabelas permanentes
SELECT Cli.nome_razaoSocial AS 'Nome',
       Con.agencia AS 'Agencia',
	   Con.numero AS 'Conta',
	   Car.numero AS 'Cartao',
	   Car.bandeira AS 'Bandeira',
	   Car.validade AS 'Validade',
	   Car.situacao AS 'Situacao'
FROM Cliente AS Cli
INNER JOIN ClienteConta AS CC ON Cli.codigo = CC.codigoCliente
INNER JOIN ClientePF AS PF ON Cli.codigo = PF.codigoCliente
INNER JOIN Conta AS Con ON CC.codigoConta = Con.codigo
INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta
WHERE Con.ativa = 1


-- Todas as restri��es do banco (relacionamentos, constraints etc.) devem ser respeitadas pela View
INSERT INTO vwClientesCartoes
VALUES('Antonia Reis Vieira', '01470', '2334455', '1122333298456325', 'MasterCard', '01/05/2025', 'bloqueado')
-- A View ou a fun��o 'vwClientesCartoes' n�o � atualiz�vel porque a modifica��o afeta v�rias tabelas base.
GO


-- Cria��o de uma View que d� acesso aos emprestimos n�o quitados e suas parcelas em aberto (mostrando tamb�m o cliente e seus telefones)








----------------------------------------------------------------------------------------------------------
-- Fun��es UDF (User Defined Functions ou Fun��es Definidas pelo Usu�rio)

/* Bloco de instru��es (objetos do Banco de Dados) que executam uma determinada funcionalidade 
   e podem ser chamados/invocados quando necess�rio

	Estrutura da fun��o
		Entrada (passagens de par�metro)
		Processamento (as instru��es da fun��o)
		Sa�da (retorno de valor)

	Varia��es
		Sem passagem de par�metro e Sem retorno de valor
		Com passagem de par�metro e Sem retorno de valor
		Sem passagem de par�metro e Com retorno de valor
		Com passagem de par�metro e Com retorno de valor

	Tipos de par�metros e/ou retornos
		Um valor (Fun��o com Valor Escalar)
		Um conjunto de valores (Fun��es com Valor de Tabela)
*/

--> Fun��o com Valor Escalar


-- CreditosDiario (Sem passagem de par�metro e Com retorno de valor)

CREATE FUNCTION fnCreditosDiario() RETURNS SMALLMONEY
AS
BEGIN

	DECLARE @Total SMALLMONEY

	SELECT @Total = SUM(Mov.valor)
	FROM Movimentacao AS Mov
	WHERE Mov.operacao = 'credito'
	  AND CAST(Mov.dataHora AS DATE) = '04/02/2023' -- GETDATE()

	RETURN @Total
END
GO


CREATE OR ALTER FUNCTION fnDebitosDiario() RETURNS SMALLMONEY
AS
BEGIN

	DECLARE @Total SMALLMONEY

	SELECT @Total = SUM(Mov.valor)
	FROM Movimentacao AS Mov
	WHERE Mov.operacao = 'debito'
	  AND CAST(Mov.dataHora AS DATE) = '04/02/2023' -- GETDATE()

	RETURN @Total
END
GO




-- ClienteInvestimentoCDB (Com passagem de par�metro e Com retorno de valor

CREATE FUNCTION fnClienteInvestimentoCDB(@Cliente INT) RETURNS SMALLMONEY
AS
BEGIN
	DECLARE @Total SMALLMONEY

	SELECT @Total = SUM(I.aporte)
	FROM Cliente AS Cli
	INNER JOIN ClienteConta AS CC ON Cli.codigo = CC.codigoCliente
	INNER JOIN Conta AS Con ON CC.codigoConta = Con.codigo
	INNER JOIN Investimento AS I ON Con.codigo = I.codigoConta
	WHERE I.tipo = 'CDB' 
	  AND I.finalizado = 0
	  AND Cli.codigo = @Cliente

	RETURN @Total

END
GO



-- D�bitos por per�odo (Com passagem de par�metro e Com retorno de valor)

CREATE FUNCTION fnDebitosPeriodo(@Inicio DATE, @Fim DATE) RETURNS SMALLMONEY
AS
BEGIN
	DECLARE @Total SMALLMONEY

	SELECT @Total = SUM(Mov.valor)
	FROM Movimentacao AS Mov
	WHERE CAST(Mov.dataHora AS DATE) BETWEEN @Inicio AND @Fim
	  AND Mov.operacao = 'debito'

	RETURN @Total
END
GO




--> Fun��es com Valor de Tabela

-- Movimenta��es di�rias

-- DROP FUNCTION dbo.fnMovimentacaoDiaria
-- GO

CREATE OR ALTER FUNCTION fnMovimentacaoDiaria (@Data DATE) RETURNS @TotaisOperacoes TABLE (TotalDebito SMALLMONEY,
                                                                                           TotalCredito SMALLMONEY,
																				           TotalTransferencia SMALLMONEY)
AS
BEGIN
	DECLARE @Debito SMALLMONEY,
	        @Credito SMALLMONEY,
			@Transferencia SMALLMONEY

	SELECT @Credito = SUM(Mov.valor)
	FROM Movimentacao AS Mov
	WHERE Mov.operacao = 'credito'
	  AND CAST(Mov.dataHora AS DATE) = @Data

	SELECT @Debito = SUM(Mov.valor)
	FROM Movimentacao AS Mov
	WHERE Mov.operacao = 'debito'
	  AND CAST(Mov.dataHora AS DATE) = @Data

	SELECT @Transferencia = SUM(Mov.valor)
	FROM Movimentacao AS Mov
	WHERE Mov.operacao = 'transferencia'
	  AND CAST(Mov.dataHora AS DATE) = @Data

	INSERT INTO @TotaisOperacoes
	VALUES(@Debito, @Credito, @Transferencia)

	RETURN
END
GO



-- Verificar cliente por CPF 

CREATE OR ALTER FUNCTION fnConsultaClientePF(@Cpf VARCHAR(15)) RETURNS VARCHAR(100)
AS 
BEGIN
	DECLARE @Retorno VARCHAR(100),
	        @LinhasAfetadas INT = 0

	SELECT @Retorno = Cli.nome_razaoSocial
	FROM Cliente AS Cli
	INNER JOIN ClientePF AS PF ON Cli.codigo = PF.codigoCliente
	WHERE PF.cpf = @Cpf
	
	SET @LinhasAfetadas = @@ROWCOUNT
	
	IF(@LinhasAfetadas = 0)
		BEGIN
			SET @Retorno = 'Cliente n�o encontrado!'
		END
	
	RETURN @Retorno
END
GO



-- Consulta totais diarios (fun��es como coluna)

SELECT dbo.fnCreditosDiario() AS 'Creditos',
       dbo.fnDebitosDiario() AS 'Debitos',
	   AVG(valor) AS 'M�dia'
FROM Movimentacao
GO

---------------------------------------------------------------------------------------
-- Stored Procedures


-- Cria��o de uma Stored Procedure para calculo dos totais de movimenta��o por conta

CREATE OR ALTER PROCEDURE stpMovimentacaoConta
	@Conta INT  -- par�metro de Valor Escalar (um dado)
AS
BEGIN
	-- Vari�ves
	DECLARE @Credito SMALLMONEY,
	        @Debito SMALLMONEY,
	        @Transferencia SMALLMONEY

	-- Calculo do total de cr�dito
	SET @Credito = (SELECT SUM(Mov.valor)
					FROM Conta AS Con
					INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta
					INNER JOIN Movimentacao AS Mov ON Car.codigo = Mov.codigoCartao
					WHERE Con.codigo = @Conta AND Mov.operacao = 'credito')

    -- Calculo do total de d�dito
	SET @Debito = (SELECT SUM(Mov.valor)
					FROM Conta AS Con
					INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta
					INNER JOIN Movimentacao AS Mov ON Car.codigo = Mov.codigoCartao
					WHERE Con.codigo = @Conta AND Mov.operacao = 'debito')

	-- Calculo do total de transfer�ncias
	SET @Transferencia = (SELECT SUM(Mov.valor)
					     FROM Conta AS Con
					     INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta
					     INNER JOIN Movimentacao AS Mov ON Car.codigo = Mov.codigoCartao
					     WHERE Con.codigo = @Conta AND Mov.operacao = 'transferencia')

	-- Consulta completa (resultado em grade)
	SELECT Con.agencia,
           Con.numero,
	       -- Car.numero,
	       -- Car.bandeira,
	       FORMAT(@Credito, 'C', 'pt-br') AS 'Total de Cr�dito',
		   FORMAT(@Debito, 'C', 'pt-br') AS 'Total de D�bito',
		   FORMAT(@Transferencia, 'C', 'pt-br') AS 'Total de Tranfer�ncia',
		   FORMAT(@Credito - (@Debito + @Transferencia), 'C', 'pt-br') AS 'Saldo'
	FROM Conta AS Con
	-- INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta
	WHERE Con.codigo = @Conta

	-- Consulta completa (resultado em mensagens)
	PRINT 'Total de Cr�dito: ' + FORMAT(@Credito, 'C', 'pt-br')
	PRINT 'Total de D�bito: ' + FORMAT(@Debito, 'C', 'pt-br')
	PRINT 'Total de Tranfer�ncia: ' + FORMAT(@Transferencia, 'C', 'pt-br')
	PRINT 'Saldo: ' + FORMAT(@Credito - (@Debito + @Transferencia), 'C', 'pt-br')

END
GO



-----------------------------------------------------------------------------------------------
-- Refatora��o da SP stpMovimentacaoConta utilizando fun��es para os calculos dos totais

-- Fun��o para calculo do total de cr�ditos por conta
CREATE OR ALTER FUNCTION fnCreditoConta(@Conta INT) RETURNS SMALLMONEY
AS
BEGIN
	-- Calculo do total de cr�dito
	RETURN (SELECT SUM(Mov.valor)
			FROM Conta AS Con
			INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta
			INNER JOIN Movimentacao AS Mov ON Car.codigo = Mov.codigoCartao
			WHERE Con.codigo = @Conta AND Mov.operacao = 'credito')
END
GO


-- Fun��o para calculo do total de d�bitos por conta
CREATE OR ALTER FUNCTION fnDebitoConta(@Conta INT) RETURNS SMALLMONEY
AS
BEGIN
	-- Calculo do total de cr�dito
	RETURN (SELECT SUM(Mov.valor)
			FROM Conta AS Con
			INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta
			INNER JOIN Movimentacao AS Mov ON Car.codigo = Mov.codigoCartao
			WHERE Con.codigo = @Conta AND Mov.operacao = 'debito')
END
GO


-- Fun��o para calculo do total de transfer�ncias por conta
CREATE OR ALTER FUNCTION fnTransferenciaConta(@Conta INT) RETURNS SMALLMONEY
AS
BEGIN
	-- Calculo do total de cr�dito
	RETURN (SELECT SUM(Mov.valor)
			FROM Conta AS Con
			INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta
			INNER JOIN Movimentacao AS Mov ON Car.codigo = Mov.codigoCartao
			WHERE Con.codigo = @Conta AND Mov.operacao = 'transferencia')
END
GO



-- SP para calculo dos totais de movimenta��o por conta
CREATE OR ALTER PROCEDURE stpMovimentacaoConta
	@Conta INT -- par�metro de Valor Escalar (um dado)
AS
BEGIN
	-- Vari�ves recebendo retornos de fun��es
	DECLARE @Credito SMALLMONEY = (SELECT dbo.fnCreditoConta(@Conta)),
	        @Debito SMALLMONEY = (SELECT dbo.fnDebitoConta(@Conta)),
	        @Transferencia SMALLMONEY  = (SELECT dbo.fnTransferenciaConta(@Conta))

	-- Consulta completa (resultado em grade)
	SELECT Con.agencia,
           Con.numero,
	       -- Car.numero,
	       -- Car.bandeira,
	       FORMAT(@Credito, 'C', 'pt-br') AS 'Total de Cr�dito',
		   FORMAT(@Debito, 'C', 'pt-br') AS 'Total de D�bito',
		   FORMAT(@Transferencia, 'C', 'pt-br') AS 'Total de Tranfer�ncia',
		   FORMAT(@Credito - (@Debito + @Transferencia), 'C', 'pt-br') AS 'Saldo'
	FROM Conta AS Con
	-- INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta
	WHERE Con.codigo = @Conta

	-- Consulta completa (resultado em mensagens)
	PRINT 'Total de Cr�dito: ' + FORMAT(@Credito, 'C', 'pt-br')
	PRINT 'Total de D�bito: ' + FORMAT(@Debito, 'C', 'pt-br')
	PRINT 'Total de Tranfer�ncia: ' + FORMAT(@Transferencia, 'C', 'pt-br')
	PRINT 'Saldo: ' + FORMAT(@Credito - (@Debito + @Transferencia), 'C', 'pt-br')

END
GO


-----------------------------------------------------------------------------------------------
-- Stored Procedure de inser��o de novo emprestimo

-- Verifica��o dos dados armazenados
/*
	SELECT * FROM Emprestimo
	SELECT * FROM EmprestimoParcela

	SELECT Cliente.codigo,
		   Cliente.nome_razaoSocial,
		   Conta.codigo,
		   Conta.agencia,
		   Conta.numero
	FROM Cliente
	INNER JOIN ClienteConta ON Cliente.codigo = ClienteConta.codigoCliente
	INNER JOIN Conta ON ClienteConta.codigoConta = Conta.codigo


	Dados que ser�o inseridos

    --> Emprestimo
        codigoConta INT
		dataSolicitacao DATE
		valorSolicitado SMALLMONEY
		juros FLOAT
		aprovado BIT
		numeroParcela INT
		dataAprovacao DATE
		observarcao VARCHAR(200)

	--> EmprestimoParcela
		codigoEmprestimo INT
		numero INT,
		dataVencimento DATE
		valorParcela SMALLMONEY
		dataPagamento DATE
		valorPago SMALLMONEY
*/


-- Cria��o do tipo tabela com os dados do emprestimo
CREATE TYPE tpEmprestimo AS TABLE(
	codigoConta INT,
	dataSolicitacao DATE,
	valorSolicitado SMALLMONEY,
	juros FLOAT,
	aprovado BIT,
	numeroParcela INT,
	dataAprovacao DATE,
	observarcao VARCHAR(200)
)
GO


-- Stored Procedure de inser��o de novo emprestimo

CREATE OR ALTER PROCEDURE stpNovoEmprestimo
	@Emprestimo tpEmprestimo READONLY -- par�metro de Valor de Tabela (conjunto de dados)
AS
BEGIN
	-- Declara��o de vari�veis
	DECLARE @CodigoConta INT,
			@DataSolicitacao DATE,
			@ValorSolicitado SMALLMONEY,
			@Juros FLOAT,
			@Aprovado BIT,
			@NumeroParcela INT,
			@DataAprovacao DATE,
			@Observarcao VARCHAR(200),

			@CodigoEmprestimo INT,
			@Numero INT = 1,
			@DataVencimento DATE,
			@ValorParcela SMALLMONEY,
			@DataPagamento DATE = NULL,
			@ValorPago SMALLMONEY = NULL

	-- Armazena os valores recebidos pelo par�metro @Emprestimo em vari�veis
	SELECT @CodigoConta = codigoConta,
		   @DataSolicitacao = dataSolicitacao,
		   @ValorSolicitado = valorSolicitado,
		   @Juros = juros,
		   @Aprovado = aprovado,
		   @NumeroParcela = numeroParcela,
		   @DataAprovacao = dataAprovacao,
		   @Observarcao = observarcao
	FROM @Emprestimo
	

	-- Inser��o em Emprestimo
	INSERT INTO Emprestimo
	VALUES(@CodigoConta, @DataSolicitacao, @ValorSolicitado, @Juros, @Aprovado, @NumeroParcela, @DataAprovacao, @Observarcao)

	-- Recupera��o do c�digo do emprestimo gerado
	SET @CodigoEmprestimo = @@IDENTITY

	-- Calculo do valores das parcelas
	SET @ValorParcela = @ValorSolicitado / @NumeroParcela

	-- Calculo do vencimento da primeira parcela
	SET @DataVencimento = DATEADD(MONTH, 1, @DataAprovacao)

	-- Looping para inser��o de quantas parcelas forem necess�rias 
	-- de acordo com o n�mero de parcelas
	WHILE(@Numero <= @NumeroParcela)
		BEGIN
		
			-- Inser��o de cada parcela
			INSERT INTO EmprestimoParcela
			VALUES(@CodigoEmprestimo, @Numero, @DataVencimento, @ValorParcela, @DataPagamento, @ValorPago)

			-- Calculo do vencimento da pr�xima parcela 
			SET @DataVencimento = DATEADD(MONTH, 1, @DataVencimento)

			-- Numeros da pr�xima parcela
			SET @Numero = @Numero + 1
		END
END
GO



-- Stored Procedure para inser��o de um novo cliente pessoa f�sica com uma nova conta (stpNovoCliente)

-- Tabelas envolvidas
/*
	SELECT * FROM Endereco
	SELECT * FROM Cliente
	SELECT * FROM ClientePF
	SELECT * FROM Contato
	SELECT * FROM ClienteConta
	SELECT * FROM Conta
	SELECT * FROM Cartao
*/

-- Cria��o de Tipos de Tabela Definidos pelo Usu�rio para passar os valores por par�metro

CREATE TYPE tpEndereco AS TABLE(
	Logradouro VARCHAR(100), 
	Bairro VARCHAR(75),
	Cidade VARCHAR(75),
	Uf CHAR(2),
	Cep CHAR(10)
)
GO

CREATE TYPE tpClientePF AS TABLE(
	NomeRazao VARCHAR(100),
	NomeSocialFantasia VARCHAR(100),
	Foto VARCHAR(100),
	DataNascAbertura DATE,
	Usuario CHAR(10), 
	Senha INT,
	Cpf VARCHAR(15), 			
	Rg VARCHAR(15)
)
GO

CREATE TYPE tpContato AS TABLE(
	NumeroTelefone VARCHAR(15), 
	Ramal VARCHAR(25),
	Email VARCHAR(50),
	Observacao VARCHAR(50)
)
GO

CREATE TYPE tpConta AS TABLE(
	Agencia VARCHAR(10), 			
	NumeroConta VARCHAR(25),
	Tipo VARCHAR(20),
	Limite SMALLMONEY,
	Ativa BIT
)
GO

CREATE TYPE tpCartao AS TABLE(
	NumeroCartao VARCHAR(30), 			
	Cvv CHAR(5),
	Validade DATE,
	Bandeira VARCHAR(20), 
	Situacao VARCHAR(20)
)
GO


-- Stored Procedure para inser��o de um novo cliente pessoa f�sica com uma nova conta
CREATE OR ALTER PROCEDURE stpNovoCliente
	@Endereco tpEndereco READONLY,  -- par�metros de Valores de Tabelas (conjuntos de dados)
	@ClientePF tpClientePF READONLY,
	@Contato tpContato READONLY,
	@Conta tpConta READONLY,
	@Cartao tpCartao READONLY
AS
BEGIN
	--Declara��o de vari�veis
	DECLARE -- Endereco
	        @CodigoEndereco INT, 
			@Logradouro VARCHAR(100), 
			@Bairro VARCHAR(75), 
			@Cidade VARCHAR(75), 
			@Uf CHAR(2), 
			@Cep CHAR(10),
			-- Cliente
			@CodigoCliente INT, 
			@NomeRazao VARCHAR(100), 
			@NomeSocialFantasia VARCHAR(100), 
			@Foto VARCHAR(100), 
			@DataNascAbertura DATE, 
			@Usuario CHAR(10), 
			@Senha INT,
			-- ClientePF
			@Cpf VARCHAR(15), 
			@Rg VARCHAR(15),
			-- Contato
			@NumeroTelefone VARCHAR(15), 
			@Ramal VARCHAR(25), 
			@Email VARCHAR(50), 
			@Observacao VARCHAR(50),
			-- Conta
			@CodigoConta INT, 
			@Agencia VARCHAR(10), 
			@NumeroConta VARCHAR(25), 
			@Tipo VARCHAR(20), 
			@Limite SMALLMONEY, 
			@Ativa BIT,
			-- Cartao 
			@NumeroCartao VARCHAR(30), 
			@Cvv CHAR(5), 
			@Validade DATE, 
			@Bandeira VARCHAR(20), 
			@Situacao VARCHAR(20)

	-- Armazena os valores recebidos pelo par�metro @Endereco em vari�veis
	SELECT @Logradouro = Logradouro, 
		   @Bairro = Bairro,
		   @Cidade = Cidade,
		   @Uf = Uf,
		   @Cep = Cep
	FROM @Endereco

	-- Armazena os valores recebidos pelo par�metro @ClientePF em vari�veis
	SELECT @NomeRazao = NomeRazao,
		   @NomeSocialFantasia = NomeSocialFantasia,
		   @Foto = Foto,
		   @DataNascAbertura = DataNascAbertura,
		   @Usuario = Usuario, 
		   @Senha = Senha,
		   @Cpf = Cpf, 			
		   @Rg = Rg
	FROM @ClientePF

	-- Armazena os valores recebidos pelo par�metro @Contato em vari�veis
	SELECT @NumeroTelefone = NumeroTelefone, 
		   @Ramal = Ramal,
		   @Email = Email,
		   @Observacao = Observacao
	FROM @Contato

	-- Armazena os valores recebidos pelo par�metro @Conta em vari�veis
	SELECT @Agencia = Agencia, 			
		   @NumeroConta = NumeroConta,
		   @Tipo = Tipo,
		   @Limite = Limite,
		   @Ativa = Ativa
	FROM @Conta

	-- Armazena os valores recebidos pelo par�metro @Cartao em vari�veis
	SELECT @NumeroCartao = NumeroCartao, 			
		   @Cvv = Cvv,
		   @Validade = Validade,
		   @Bandeira = Bandeira, 
		   @Situacao = Situacao
	FROM @Cartao


	-- Inser��o do endere�o
	INSERT INTO Endereco
	VALUES(@Logradouro, @Bairro, @Cidade, @Uf, @Cep)
	-- Recupera��o do codigo gerado
	SET @CodigoEndereco = @@IDENTITY

	-- Inser��o do Cliente (generaliza��o)
	INSERT INTO Cliente
	VALUES(@CodigoEndereco, @NomeRazao, @NomeSocialFantasia, @Foto, @DataNascAbertura, @Usuario, @Senha)
	-- Recupera��o do codigo gerado
	SET @CodigoCliente = @@IDENTITY
	-- Altera��o do atributo foto_logo
	UPDATE Cliente
	SET foto_logo = CONCAT('\fotos\',@CodigoCliente,'.jpg')
	WHERE codigo = @CodigoCliente

	-- Inser��o do ClientePF (especializa��o)
	INSERT INTO ClientePF
	VALUES(@CodigoCliente, @Cpf, @Rg)

	-- Inser��o do Contato
	INSERT INTO Contato
	VALUES(@CodigoCliente, @NumeroTelefone, @Ramal, @Email, @Observacao)

	-- Inser��o da Conta
	INSERT INTO Conta
	VALUES(@Agencia, @NumeroConta, @Tipo, @Limite, @Ativa)
	-- Recupera��o do codigo gerado
	SET @CodigoConta = @@IDENTITY

	-- Relacionamento entre Cliente e Conta
	INSERT INTO ClienteConta
	VALUES(@CodigoCliente, @CodigoConta)

	-- Inser��o do Cart�o
	INSERT INTO Cartao
	VALUES(@CodigoConta, @NumeroCartao, @Cvv, @Validade, @Bandeira, @Situacao)

END
GO




-- SP para consultar o valor total para quita��o de um emprestimo.

CREATE OR ALTER PROCEDURE stpTotalQuitacaoEmprestimo
	@CodEmprestimo INT,
	@Valor SMALLMONEY OUTPUT -- par�metro de sa�da (retorno)
AS
BEGIN

	SELECT @Valor = SUM(Parcela.valorParcela)
	FROM Emprestimo AS E
	INNER JOIN EmprestimoParcela AS Parcela ON E.codigo = Parcela.codigoEmprestimo
	WHERE E.codigo = @CodEmprestimo AND Parcela.valorPago IS NOT NULL

END
GO



-- SP para consultar as parcelas para quita��o de um emprestimo.

-- Cria��o de Tipos de Tabela Definidos pelo Usu�rio para passar os valores por par�metro
CREATE TYPE tpParcelasEmprestimo AS TABLE(
	numero INT,	
	valor SMALLMONEY,
	venvimento DATE
)
GO


-- SP para consultar as parcelas para quita��o de um emprestimo.
CREATE OR ALTER PROCEDURE stpParcelasQuitacaoEmprestimo
	@CodEmprestimo INT
AS
BEGIN
	
	-- Executa a consulta que apresenta as parcelas
	SELECT Parcela.numero,
	       Parcela.valorParcela,
		   Parcela.dataVencimento
	FROM Emprestimo AS E
	INNER JOIN EmprestimoParcela AS Parcela ON E.codigo = Parcela.codigoEmprestimo
	WHERE E.codigo = @CodEmprestimo AND Parcela.valorPago IS NOT NULL

END
GO



-- Cria��o de uma nova conta de investimentos para clientes PJ, com um cart�o MasterCard e um investimento
-- de R$ 10.000,00 em a��es a curto prazo com taxa administrativa zero (stpContaInvestimentoPJ)

CREATE TYPE tpInvestimento AS TABLE(
	TipoInvestimento VARCHAR(30),
	Aporte SMALLMONEY,
	TaxaAdminstrativa FLOAT,
	Prazo VARCHAR(20),
	Risco CHAR(5),
	Rentabilidade SMALLMONEY, 
	Finalizado BIT
)
GO


CREATE OR ALTER PROCEDURE stpContaInvestimentoPJ
	@Conta tpConta READONLY,
	@Cartao tpCartao READONLY,	
	@Investimento tpInvestimento READONLY
AS
BEGIN
	DECLARE -- Conta
			@Agencia VARCHAR(10),
			@NumeroConta VARCHAR(25),
			@TipoConta VARCHAR(20),
			@Limite SMALLMONEY,
			@Ativa BIT,
			-- Cartao
			@CodigoConta INT,
			@NumeroCartao VARCHAR(30),
			@Cvv CHAR(5),
			@Validade DATE,
			@Bandeira VARCHAR(20),
			@Situacao VARCHAR(20),
			-- Investimento
			@TipoInvestimento VARCHAR(30),
			@Aporte SMALLMONEY,
			@TaxaAdminstrativa FLOAT,
			@Prazo VARCHAR(20),
			@Risco CHAR(5),
			@Rentabilidade SMALLMONEY, 
			@Finalizado BIT

	-- Armazena os valores recebidos pelo par�metro @Conta em vari�veis
	SELECT @Agencia = Agencia, 			
		   @NumeroConta = NumeroConta,
		   @TipoConta = Tipo,
		   @Limite = Limite,
		   @Ativa = Ativa
	FROM @Conta

	-- Armazena os valores recebidos pelo par�metro @Cartao em vari�veis
	SELECT @NumeroCartao = NumeroCartao, 			
		   @Cvv = Cvv,
		   @Validade = Validade,
		   @Bandeira = Bandeira, 
		   @Situacao = Situacao
	FROM @Cartao

	-- Armazena os valores recebidos pelo par�metro @Investimento em vari�veis
	SELECT @TipoInvestimento = TipoInvestimento,
		   @Aporte = Aporte,
		   @TaxaAdminstrativa = TaxaAdminstrativa,
		   @Prazo = Prazo,
		   @Risco = Risco,
		   @Rentabilidade = Rentabilidade, 
		   @Finalizado = Finalizado
	FROM @Investimento


	INSERT INTO Conta
	VALUES(@Agencia, @NumeroConta, @TipoConta, @Limite, @Ativa)

	SET @CodigoConta = @@IDENTITY

	INSERT INTO Cartao
	VALUES(@CodigoConta, @NumeroCartao, @Cvv, @Validade, @Bandeira, @Situacao)

	INSERT INTO Investimento
	VALUES(@CodigoConta, @TipoInvestimento, @Aporte, @TaxaAdminstrativa, @Prazo, @Risco, @Rentabilidade, @Finalizado)

END
GO


------------------------------------------------------------------------------------------
-- Gera��o de arquivos

-- XML
-- https://learn.microsoft.com/pt-br/sql/relational-databases/xml/xml-data-sql-server


-- SP para calculo dos totais de movimenta��o por conta (gerando arquivo XML)
CREATE OR ALTER PROCEDURE stpMovimentacaoContaXML
	@Conta INT,                 -- par�metro de Valor Escalar (um dado)
	@MovimentacaoXML XML OUTPUT -- par�metro de sa�da 	
AS
BEGIN
	-- Vari�ves recebendo retornos de fun��es
	DECLARE @Credito SMALLMONEY = (SELECT dbo.fnCreditoConta(@Conta)),
	        @Debito SMALLMONEY = (SELECT dbo.fnDebitoConta(@Conta)),
	        @Transferencia SMALLMONEY  = (SELECT dbo.fnTransferenciaConta(@Conta))

	-- Consulta gerando um arquivo XML
	SET @MovimentacaoXML = (SELECT Con.agencia,
								   Con.numero,
								   -- Car.numero,
								   -- Car.bandeira,
								   FORMAT(@Credito, 'C', 'pt-br') AS 'TotalCredito',
								   FORMAT(@Debito, 'C', 'pt-br') AS 'TotalDebito',
								   FORMAT(@Transferencia, 'C', 'pt-br') AS 'TotalTranferencia',
								   FORMAT(@Credito - (@Debito + @Transferencia), 'C', 'pt-br') AS 'Saldo'
							FROM Conta AS Con
							-- INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta
							WHERE Con.codigo = @Conta
							FOR XML AUTO)
END
GO

-- Execu��o da SP
DECLARE @Retorno XML
                          
EXEC stpMovimentacaoContaXML @Conta = 1,
                          @MovimentacaoXML = @Retorno OUTPUT

SELECT @Retorno
GO


-- V�rios registros de retorno

-- SP para consultar as parcelas para quita��o de um emprestimo (gerando arquivo XML)
CREATE OR ALTER PROCEDURE stpParcelasQuitacaoEmprestimoXML
	@CodEmprestimo INT
AS
BEGIN
	
	SELECT Parcela.numero,
	       Parcela.valorParcela,
		   Parcela.dataVencimento
	FROM Emprestimo AS E
	INNER JOIN EmprestimoParcela AS Parcela ON E.codigo = Parcela.codigoEmprestimo
	WHERE E.codigo = @CodEmprestimo AND Parcela.valorPago IS NOT NULL
	FOR XML AUTO

END
GO

-- Execu��o da SP
EXEC stpParcelasQuitacaoEmprestimoXML @CodEmprestimo = 1
GO




-- JSON
-- https://learn.microsoft.com/pt-br/sql/t-sql/functions/json-functions-transact-sql


-- SP para calculo dos totais de movimenta��o por conta (gerando arquivo JSON)
CREATE OR ALTER PROCEDURE stpMovimentacaoContaJSON
	@Conta INT,                           -- par�metro de Valor Escalar (um dado)
	@MovimentacaoJSON VARCHAR(MAX) OUTPUT -- par�metro de sa�da 	
AS
BEGIN
	-- Vari�ves recebendo retornos de fun��es
	DECLARE @Credito SMALLMONEY = (SELECT dbo.fnCreditoConta(@Conta)),
	        @Debito SMALLMONEY = (SELECT dbo.fnDebitoConta(@Conta)),
	        @Transferencia SMALLMONEY  = (SELECT dbo.fnTransferenciaConta(@Conta))

	-- Consulta gerando um arquivo JSON
	SET @MovimentacaoJSON = (SELECT Con.agencia,
								   Con.numero,
								   -- Car.numero,
								   -- Car.bandeira,
								   FORMAT(@Credito, 'C', 'pt-br') AS 'TotalCredito',
								   FORMAT(@Debito, 'C', 'pt-br') AS 'TotalDebito',
								   FORMAT(@Transferencia, 'C', 'pt-br') AS 'TotalTranferencia',
								   FORMAT(@Credito - (@Debito + @Transferencia), 'C', 'pt-br') AS 'Saldo'
							FROM Conta AS Con
							-- INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta
							WHERE Con.codigo = @Conta
							FOR JSON AUTO)
END
GO


-- Execu��o da SP
DECLARE @Retorno VARCHAR(MAX)
                          
EXEC stpMovimentacaoContaJSON @Conta = 1,
                              @MovimentacaoJSON = @Retorno OUTPUT

SELECT @Retorno
GO


------------------------------
-- V�rios registros de retorno

-- SP para consultar as parcelas para quita��o de um emprestimo (gerando arquivo JSON).
CREATE OR ALTER PROCEDURE stpParcelasQuitacaoEmprestimoJSON
	@CodEmprestimo INT
AS
BEGIN
	
	SELECT Parcela.numero,
	       Parcela.valorParcela,
		   Parcela.dataVencimento
	FROM Emprestimo AS E
	INNER JOIN EmprestimoParcela AS Parcela ON E.codigo = Parcela.codigoEmprestimo
	WHERE E.codigo = @CodEmprestimo AND Parcela.valorPago IS NOT NULL
	FOR JSON AUTO

END
GO

-- Execu��o da SP
EXEC stpParcelasQuitacaoEmprestimoJSON @CodEmprestimo = 1
GO


-----------------------------------------------------------------------------------------------------------
-- Exporta��o para o Excel
/*
No Excel

	Menu Dados > Obter Dados > Do Banco de Dados > Do Banco de Dados SQL Server

		Servidor: <seu servidor> (se a conex�o for remota: IP e Porta (padr�o do SQL Server 1433))
		Banco de Dados: FastBank

		Op��es avan�adas
			Instru��o SQL:
			stpParcelasQuitacaoEmprestimo @CodEmprestimo = 1

		Banco de Dados
			Nome do us�rio: sa
			Senha: <sua senha>
*/


-----------------------------------------------------------------------------------------------------------
-- Importa��o do Excel 
/*
Obter planilha com dados
Bot�o direito sobre o Banco onde deseja acrescentar a tabela
	Tarefas
		Importar Arquivo Simples
			Selecionar o arquivo
			Ajustar os tipos de dados e restri��es (permitir nulos)
*/


-- Exemplo campeonato-brasileiro-full
-- https://github.com/adaoduque/Brasileirao_Dataset


SELECT * FROM CampeonatoBrasileiro

SELECT Brasileirao.[data],
       Brasileirao.mandante,
	   Brasileirao.mandante_Placar,
       Brasileirao.visitante,
	   Brasileirao.visitante_Placar
FROM CampeonatoBrasileiro AS Brasileirao
WHERE Brasileirao.mandante = 'Corinthians' 
  AND Brasileirao.mandante_Placar > Brasileirao.visitante_Placar
  AND YEAR(Brasileirao.[data]) = 2022



-----------------------------------------------------------------------------------------------------------
-- Trigger
-- https://learn.microsoft.com/pt-br/sql/t-sql/statements/create-trigger-transact-sql?view=sql-server-ver16
/*
AFTER -> Executada DEPOIS de uma modifica��o (INSERT, UPDATE ou  DELETE)
INSTEAD OF -> Executada EM VEZ DE de uma modifica��o (INSERT, UPDATE ou  DELETE)
              (a instru��o original que disparou a TRIGGER � ignorada)

Recupera��o de dados: tabela tempor�rias do SQL Server (atualizadas depois do registro no log de transa��es)
                      onde ficam dispon�veis as informa��es da instru��o que acabou de ser executada. 

INSERT -> inserted
DELETE -> deleted
UPDATE -> deleted e inserted
*/

USE FastBank

-- Alterar a tabela Conta acrescentando um campo saldo SMALLMONEY
ALTER TABLE Conta
ADD saldo SMALLMONEY
GO

UPDATE Conta
SET saldo = 0
GO

SELECT * FROM Conta
GO


-- Criar uma Trigger que atualiza o saldo (Conta) a cada inser��o na tabela Movimentacao
CREATE OR ALTER TRIGGER trgAtualizarSaldo
ON Movimentacao
AFTER INSERT AS
BEGIN
	DECLARE @CodigoConta INT,
	        @CodigoCartao INT,
			@Operacao VARCHAR(25),
			@Valor SMALLMONEY
	
	-- Recupera das da ultima inser��o em Movimentacao
	SELECT @CodigoCartao = CodigoCartao,
	       @Operacao = Operacao,
		   @Valor = Valor
	FROM inserted

	-- Obt�m a Conta
	SET @CodigoConta = (SELECT Conta.codigo 
						FROM Conta
						INNER JOIN Cartao ON Conta.codigo = Cartao.codigoConta
						WHERE Cartao.codigo = @CodigoCartao)

	-- Atualiza o saldo (em Conta)
	IF(@Operacao = 'credito')
		BEGIN
			UPDATE Conta
			SET	saldo = saldo + @Valor
			WHERE codigo = @CodigoConta
		END
	
	IF(@Operacao = 'debito')
		BEGIN
			UPDATE Conta
			SET	saldo = saldo - @Valor
			WHERE codigo = @CodigoConta
		END
END


-- Testes

-- Verifica o saldo atual
SELECT Conta.saldo 
FROM Conta
INNER JOIN Cartao ON Conta.codigo = Cartao.codigoConta
WHERE Cartao.codigo = 1


-- Inser��o de um d�bito em Movimentacao
INSERT INTO Movimentacao
	(codigoCartao, codigoContaDestino, dataHora, operacao, valor)
VALUES
	(1, NULL, GETDATE(), 'credito', 1000.00)


-- Verifica o lan�amento em Movimenta��o
SELECT Movimentacao.codigo,
       Movimentacao.operacao,
       Movimentacao.valor
FROM Movimentacao
WHERE Movimentacao.codigo = (SELECT MAX(Movimentacao.codigo) FROM Movimentacao)
-- Verifica o saldo atual
SELECT Conta.saldo 
FROM Conta
INNER JOIN Cartao ON Conta.codigo = Cartao.codigoConta
WHERE Cartao.codigo = 1


-- Inser��o de um cr�dito em Movimentacao
INSERT INTO Movimentacao
	(codigoCartao, codigoContaDestino, dataHora, operacao, valor)
VALUES
	(1, NULL, GETDATE(), 'credito', 1250.00)


-- Verifica o lan�amento em Movimenta��o
SELECT Movimentacao.codigo,
       Movimentacao.operacao,
       Movimentacao.valor
FROM Movimentacao
WHERE Movimentacao.codigo = (SELECT MAX(Movimentacao.codigo) FROM Movimentacao)
-- Verifica o saldo atual
SELECT Conta.saldo 
FROM Conta
INNER JOIN Cartao ON Conta.codigo = Cartao.codigoConta
WHERE Cartao.codigo = 1


-- Inser��o de um cr�dito em Movimentacao
INSERT INTO Movimentacao
	(codigoCartao, codigoContaDestino, dataHora, operacao, valor)
VALUES
	(1, NULL, GETDATE(), 'credito', 250.00)


-- Verifica o lan�amento em Movimenta��o
SELECT Movimentacao.codigo,
       Movimentacao.operacao,
       Movimentacao.valor
FROM Movimentacao
WHERE Movimentacao.codigo = (SELECT MAX(Movimentacao.codigo) FROM Movimentacao)
-- Verifica o saldo atual
SELECT Conta.saldo 
FROM Conta
INNER JOIN Cartao ON Conta.codigo = Cartao.codigoConta
WHERE Cartao.codigo = 1



-- Alterar a tabela Movimentacao acrescentando um campo estorno BIT

ALTER TABLE Movimentacao
ADD estorno BIT
GO

UPDATE Movimentacao
SET estorno = 0

SELECT * FROM Movimentacao
GO



-- Criar uma Trigger que identifica o estorne de uma movimenta��o
CREATE OR ALTER TRIGGER trgEstornoMovimentacao
ON Movimentacao
FOR UPDATE AS
BEGIN

	DECLARE @CodigoConta INT,
	        @CodigoCartao INT,
			@Operacao VARCHAR(25),
			@Valor SMALLMONEY
	
	-- Recupera das da ultima inser��o em Movimentacao
	SELECT @CodigoCartao = CodigoCartao,
	       @Operacao = Operacao,
		   @Valor = Valor
	FROM deleted

	-- Obt�m a Conta
	SET @CodigoConta = (SELECT Conta.codigo 
						FROM Conta
						INNER JOIN Cartao ON Conta.codigo = Cartao.codigoConta
						WHERE Cartao.codigo = @CodigoCartao)

	-- Corrige o saldo
	IF(@Operacao = 'credito')
		BEGIN
			UPDATE Conta
			SET	saldo = saldo - @Valor
			WHERE codigo = @CodigoConta
		END
	
	IF(@Operacao = 'debito')
		BEGIN
			UPDATE Conta
			SET	saldo = saldo + @Valor
			WHERE codigo = @CodigoConta
		END

END
GO

-- Testes

-- Verifica o saldo atual
SELECT Conta.saldo 
FROM Conta
INNER JOIN Cartao ON Conta.codigo = Cartao.codigoConta
WHERE Cartao.codigo = 1


-- Estorno (Altera��o) de movimenta��o
UPDATE Movimentacao
SET estorno = 1
WHERE codigo = 55
GO

-- Verifica o lan�amento em Movimenta��o
SELECT Movimentacao.codigo,
       Movimentacao.operacao,
       Movimentacao.valor,
	   Movimentacao.estorno
FROM Movimentacao
WHERE Movimentacao.codigo = 55
-- Verifica o saldo atual
SELECT Conta.saldo 
FROM Conta
INNER JOIN Cartao ON Conta.codigo = Cartao.codigoConta
WHERE Cartao.codigo = 1



-- Estorno (Altera��o) de movimenta��o
UPDATE Movimentacao
SET estorno = 1
WHERE codigo = 56
GO


-- Verifica o lan�amento em Movimenta��o
SELECT Movimentacao.codigo,
       Movimentacao.operacao,
       Movimentacao.valor,
	   Movimentacao.estorno
FROM Movimentacao
WHERE Movimentacao.codigo = 56
-- Verifica o saldo atual
SELECT Conta.saldo 
FROM Conta
INNER JOIN Cartao ON Conta.codigo = Cartao.codigoConta
WHERE Cartao.codigo = 1
GO



-- Criar uma Trigger que identifica o estorne de uma movimenta��o 
-- (verificando se a movimenta��o j� foi estornada)
CREATE OR ALTER TRIGGER trgEstornoMovimentacao
ON Movimentacao
INSTEAD OF UPDATE AS
BEGIN
	DECLARE @CodigoMovimentacao INT,
	        @CodigoConta INT,
	        @CodigoCartao INT,
			@Operacao VARCHAR(25),
			@Valor SMALLMONEY,
			@Estorno BIT

	-- Recupera das da ultima inser��o em Movimentacao
	SELECT @CodigoMovimentacao = codigo,
	       @CodigoCartao = codigoCartao,
		   @Operacao = operacao,
		   @Valor = valor,
		   @Estorno = estorno
	FROM deleted

	IF(@Estorno = 0)
		BEGIN
			-- Obt�m a Conta
			SET @CodigoConta = (SELECT Conta.codigo 
								FROM Conta
								INNER JOIN Cartao ON Conta.codigo = Cartao.codigoConta
								WHERE Cartao.codigo = @CodigoCartao)

			-- Corrige o saldo
			IF(@Operacao = 'credito')
				BEGIN
					UPDATE Conta
					SET	saldo = saldo - @Valor
					WHERE codigo = @CodigoConta
				END
	
			IF(@Operacao = 'debito')
				BEGIN
					UPDATE Conta
					SET	saldo = saldo + @Valor
					WHERE codigo = @CodigoConta
				END

			-- Executa a altera��o (EM VEZ DA instru��o que "disparou" a trigger)
			UPDATE Movimentacao
			SET estorno = 1
			WHERE codigo = @CodigoMovimentacao
		END
	ELSE
		PRINT 'Movimenta��o j� estornada!'

END
GO


-- Testes

-- Verifica o lan�amento em Movimenta��o
SELECT Movimentacao.codigo,
       Movimentacao.operacao,
       Movimentacao.valor,
	   Movimentacao.estorno
FROM Movimentacao
WHERE Movimentacao.codigo = 47
-- Verifica o saldo atual
SELECT Conta.saldo 
FROM Conta
INNER JOIN Cartao ON Conta.codigo = Cartao.codigoConta
WHERE Cartao.codigo = 1

-- Estorno (Altera��o) de movimenta��o
UPDATE Movimentacao
SET estorno = 1
WHERE codigo = 47

-- Verifica o lan�amento em Movimenta��o
SELECT Movimentacao.codigo,
       Movimentacao.operacao,
       Movimentacao.valor,
	   Movimentacao.estorno
FROM Movimentacao
WHERE Movimentacao.codigo = 47
-- Verifica o saldo atual
SELECT Conta.saldo 
FROM Conta
INNER JOIN Cartao ON Conta.codigo = Cartao.codigoConta
WHERE Cartao.codigo = 1




-- Crie uma TRIGGER (trgVerificaLimite) que a cada movimenta��o de d�bito verifica o limite do cliente,
-- caso o limite seja ultrapassado, n�o efetua a movimenta��o e apresenta uma mensagem de 'Limite insuficiente!'
