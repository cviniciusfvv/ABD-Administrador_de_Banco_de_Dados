/*---------------------------------------------
Banco: FastBank
Autor: Ralfe
�ltima altera��o: 19/04/2023 - 21:30 - Ralfe
Descri��o: Introdu��o ao Transact SQL
--------------------------------------------*/
/* Documenta��o:

	Bloco de instru��es/lote/batch
	https://learn.microsoft.com/pt-br/sql/t-sql/language-elements/begin-end-transact-sql

	Vari�veis
	https://learn.microsoft.com/pt-br/sql/t-sql/language-elements/declare-local-variable-transact-sql

*/


-- Conex�o com o Banco
USE Fastbank
GO

SELECT * FROM Conta
SELECT * FROM Cartao
SELECT * FROM Movimentacao

-- Consulta os totais de cr�ditos, d�bitos e tranfer�ncias e o saldo de uma determinada conta

	-- Todos as movimenta��es de uma determinada conta
	SELECT Con.agencia,
		   Con.numero,
		   Car.numero,
		   Car.bandeira,
		   Mov.operacao,
		   Mov.valor
	FROM Conta AS Con
	INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta
	INNER JOIN Movimentacao AS Mov ON Car.codigo = Mov.codigoCartao
	WHERE Con.codigo = 1
	ORDER BY Con.agencia, Con.numero, Car.numero, Mov.operacao
	GO


	-- As movimenta��es agrupadas por opera��o
	SELECT Con.agencia,
		   Con.numero,
		   Car.numero,
		   Car.bandeira,
		   Mov.operacao,
		   SUM(Mov.valor)
	FROM Conta AS Con
	INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta
	INNER JOIN Movimentacao AS Mov ON Car.codigo = Mov.codigoCartao
	WHERE Con.codigo = 1
	GROUP BY Mov.operacao, Con.agencia, Con.numero, Car.numero, Car.bandeira
	GO


	-- Totais de cr�dito
	SELECT SUM(Mov.valor)
	FROM Conta AS Con
	INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta
	INNER JOIN Movimentacao AS Mov ON Car.codigo = Mov.codigoCartao
	WHERE Con.codigo = 1 AND Mov.operacao = 'credito'

	-- Totais de d�bito
	SELECT SUM(Mov.valor)
	FROM Conta AS Con
	INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta
	INNER JOIN Movimentacao AS Mov ON Car.codigo = Mov.codigoCartao
	WHERE Con.codigo = 1 AND Mov.operacao = 'debito'

	-- Totais de transfer�ncia
	SELECT SUM(Mov.valor)
	FROM Conta AS Con
	INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta
	INNER JOIN Movimentacao AS Mov ON Car.codigo = Mov.codigoCartao
	WHERE Con.codigo = 1 AND Mov.operacao = 'transferencia'
	GO


--------------------------------------------------------------------------
-- Instru��es em lote/bloco

BEGIN -- In�cio do bloco

	-- Vari�ves
	DECLARE @Credito SMALLMONEY,
	        @Debito SMALLMONEY,
	        @Transferencia SMALLMONEY

	-- Calculo do total de cr�dito
	SET @Credito = (SELECT SUM(Mov.valor)
					FROM Conta AS Con
					INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta
					INNER JOIN Movimentacao AS Mov ON Car.codigo = Mov.codigoCartao
					WHERE Con.codigo = 1 AND Mov.operacao = 'credito')

    -- Calculo do total de d�dito
	SET @Debito = (SELECT SUM(Mov.valor)
					FROM Conta AS Con
					INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta
					INNER JOIN Movimentacao AS Mov ON Car.codigo = Mov.codigoCartao
					WHERE Con.codigo = 1 AND Mov.operacao = 'debito')

	-- Calculo do total de transfer�ncias
	SET @Transferencia = (SELECT SUM(Mov.valor)
					     FROM Conta AS Con
					     INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta
					     INNER JOIN Movimentacao AS Mov ON Car.codigo = Mov.codigoCartao
					     WHERE Con.codigo = 1 AND Mov.operacao = 'transferencia')

	-- Consulta completa (resultado em grade)
	SELECT Con.agencia,
           Con.numero,
	       Car.numero,
	       Car.bandeira,
	       FORMAT(@Credito, 'C', 'pt-br') AS 'Total de Cr�dito',
		   FORMAT(@Debito, 'C', 'pt-br') AS 'Total de D�bito',
		   FORMAT(@Transferencia, 'C', 'pt-br') AS 'Total de Tranfer�ncia',
		   FORMAT(@Credito - (@Debito + @Transferencia), 'C', 'pt-br') AS 'Saldo'
	FROM Conta AS Con
	INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta
	WHERE Con.codigo = 1

	-- Apresentando o resultado como Mensagem
	/* Com CAST
	PRINT 'Total de Cr�dito: ' + CAST(@Credito AS VARCHAR)
	PRINT 'Total de D�bito: ' + CAST(@Debito AS VARCHAR)
	PRINT 'Total de Tranfer�ncia: ' + CAST(@Tranferencia AS VARCHAR)
	PRINT 'Saldo: ' + CAST(@Credito - (@Debito + @Transferencia) AS VARCHAR) */

	-- Com FORMAT
	PRINT 'Total de Cr�dito: ' + FORMAT(@Credito, 'C', 'pt-br')
	PRINT 'Total de D�bito: ' + FORMAT(@Debito, 'C', 'pt-br')
	PRINT 'Total de Tranfer�ncia: ' + FORMAT(@Tranferencia, 'C', 'pt-br')
	PRINT 'Saldo: ' + FORMAT(@Credito - (@Debito + @Transferencia), 'C', 'pt-br')

END -- Fim do bloco
GO



-- Retirar valores fixos para possibilitar reuso

BEGIN -- In�cio do bloco

	-- Vari�ves
	DECLARE @Conta INT = 1,
	        @Credito SMALLMONEY,
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

END -- Fim do bloco
GO


--------------------------------------------------------------------------------------
-- Inser��o que impacta mais de uma tabela

-- Inse��o de Cliente Pessoa F�sica


SELECT * 
FROM Cliente AS Cli
INNER JOIN ClientePF AS PF ON Cli.codigo = PF.codigoCliente

-- Inser��o do endere�o
-- Recuperar o c�digo do novo endere�o
-- Inserir os dados em Cliente
-- Recuperar o c�digo (chave prim�ria) gerada
-- Alterar o nome do arquivos da foto (reutiliza o c�digo do Cliente)
-- Inserir os dados em ClientePF

SELECT * FROM Endereco
SELECT * FROM Cliente
SELECT * FROM ClientePF

BEGIN
	-- Declara��es de vari�veis
	DECLARE @CodigoEndereco INT,
			@Logradouro VARCHAR(100) = 'Jos� Bonif�cio, 123',
			@Bairro VARCHAR(75) = 'Santo Ant�nio',
			@Cidade VARCHAR(75) = 'Palmas',
			@Uf CHAR(2) = 'TO',
			@Cep CHAR(10) = '78889-396',
			@CodigoCliente INT,
			@Nome VARCHAR(100) = 'Alucin�tica Campos Costa',
			@NomeSocial VARCHAR(100) = 'Fernanda Campos Costa',
			@Foto VARCHAR(100) = '',
			@DataNasc DATE = '19/04/1986',
			@Usuario CHAR(10) = 'fer',
			@Senha INT = 468798,
			@Cpf VARCHAR(15) = '38827761101',
			@Rg VARCHAR(15) = 'TO-58.407.391'

	-- Inser��o do endere�o
	INSERT INTO Endereco
	VALUES(@Logradouro, @Bairro, @Cidade, @Uf, @Cep)

	-- Recupera��o do c�digo gerado para o endere�o
	SET @CodigoEndereco = (SELECT MAX(codigo) FROM Endereco)

	-- Inser��o do cliente (generaliza��o)
	INSERT INTO Cliente
	VALUES(@CodigoEndereco, @Nome, @NomeSocial, @Foto, @DataNasc, @Usuario, @Senha)

	-- Recupera��o do c�digo gerado para o cliente
	SELECT @CodigoCliente = MAX(codigo)
	FROM Cliente

	-- Altera��o do caminho\nome da foto (reutilizando o c�digo do cliente)
	UPDATE Cliente
	SET foto_logo = CONCAT('\fotos\',@CodigoCliente,'.jpg')
	WHERE codigo = @CodigoCliente

	-- Inser��o do ClientePF (especializa��o)
	INSERT INTO ClientePF
	VALUES(@CodigoCliente, @Cpf, @Rg)

	-- Verifica��o dos resultados
	SELECT * 
	FROM Cliente AS Cli
	INNER JOIN ClientePF AS PF ON Cli.codigo = PF.codigoCliente
	INNER JOIN Endereco AS E ON Cli.codigoEndereco = E.codigo
	WHERE Cli.codigo = @CodigoCliente

END
GO


-- Nova inser��o

BEGIN
	-- Declara��es de vari�veis
	DECLARE @CodigoEndereco INT,
			@Logradouro VARCHAR(100) = 'Rua da Paz, 456',
			@Bairro VARCHAR(75) = 'Vila Industrial',
			@Cidade VARCHAR(75) = 'Petrolina',
			@Uf CHAR(2) = 'PE',
			@Cep CHAR(10) = '64938-852',
			@CodigoCliente INT,
			@Nome VARCHAR(100) = 'Marcos Castro Andrade',
			@NomeSocial VARCHAR(100) = NULL,
			@Foto VARCHAR(100) = '',
			@DataNasc DATE = '19/04/2002',
			@Usuario CHAR(10) = 'marcos',
			@Senha INT = 3259,
			@Cpf VARCHAR(15) = '91213597927',
			@Rg VARCHAR(15) = 'PE-33.239.574'

	-- Inser��o do endere�o
	INSERT INTO Endereco
	VALUES(@Logradouro, @Bairro, @Cidade, @Uf, @Cep)

	-- Recupera��o do c�digo gerado para o endere�o
	SET @CodigoEndereco = (SELECT MAX(codigo) FROM Endereco)

	-- Inser��o do cliente (generaliza��o)
	INSERT INTO Cliente
	VALUES(@CodigoEndereco, @Nome, @NomeSocial, @Foto, @DataNasc, @Usuario, @Senha)

	-- Recupera��o do c�digo gerado para o cliente
	SELECT @CodigoCliente = MAX(codigo)
	FROM Cliente

	-- Altera��o do caminho\nome da foto (reutilizando o c�digo do cliente)
	UPDATE Cliente
	SET foto_logo = CONCAT('\fotos\',@CodigoCliente,'.jpg')
	WHERE codigo = @CodigoCliente

	-- Inser��o do ClientePF (especializa��o)
	INSERT INTO ClientePF
	VALUES(@CodigoCliente, @Cpf, @Rg)

	-- Verifica��o dos resultados
	SELECT * 
	FROM Cliente AS Cli
	INNER JOIN ClientePF AS PF ON Cli.codigo = PF.codigoCliente
	INNER JOIN Endereco AS E ON Cli.codigoEndereco = E.codigo
	WHERE Cli.codigo = @CodigoCliente

END
GO