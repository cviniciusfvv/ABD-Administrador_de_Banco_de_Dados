/*---------------------------------------------
Banco: FastBank
Autor: Ralfe
Última alteração: 19/04/2023 - 21:30 - Ralfe
Descrição: Introdução ao Transact SQL
--------------------------------------------*/
/* Documentação:

	Bloco de instruções/lote/batch
	https://learn.microsoft.com/pt-br/sql/t-sql/language-elements/begin-end-transact-sql

	Variáveis
	https://learn.microsoft.com/pt-br/sql/t-sql/language-elements/declare-local-variable-transact-sql

*/


-- Conexão com o Banco
USE Fastbank
GO

SELECT * FROM Conta
SELECT * FROM Cartao
SELECT * FROM Movimentacao

-- Consulta os totais de créditos, débitos e tranferências e o saldo de uma determinada conta

	-- Todos as movimentações de uma determinada conta
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


	-- As movimentações agrupadas por operação
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


	-- Totais de crédito
	SELECT SUM(Mov.valor)
	FROM Conta AS Con
	INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta
	INNER JOIN Movimentacao AS Mov ON Car.codigo = Mov.codigoCartao
	WHERE Con.codigo = 1 AND Mov.operacao = 'credito'

	-- Totais de débito
	SELECT SUM(Mov.valor)
	FROM Conta AS Con
	INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta
	INNER JOIN Movimentacao AS Mov ON Car.codigo = Mov.codigoCartao
	WHERE Con.codigo = 1 AND Mov.operacao = 'debito'

	-- Totais de transferência
	SELECT SUM(Mov.valor)
	FROM Conta AS Con
	INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta
	INNER JOIN Movimentacao AS Mov ON Car.codigo = Mov.codigoCartao
	WHERE Con.codigo = 1 AND Mov.operacao = 'transferencia'
	GO


--------------------------------------------------------------------------
-- Instruções em lote/bloco

BEGIN -- Início do bloco

	-- Variáves
	DECLARE @Credito SMALLMONEY,
	        @Debito SMALLMONEY,
	        @Transferencia SMALLMONEY

	-- Calculo do total de crédito
	SET @Credito = (SELECT SUM(Mov.valor)
					FROM Conta AS Con
					INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta
					INNER JOIN Movimentacao AS Mov ON Car.codigo = Mov.codigoCartao
					WHERE Con.codigo = 1 AND Mov.operacao = 'credito')

    -- Calculo do total de dédito
	SET @Debito = (SELECT SUM(Mov.valor)
					FROM Conta AS Con
					INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta
					INNER JOIN Movimentacao AS Mov ON Car.codigo = Mov.codigoCartao
					WHERE Con.codigo = 1 AND Mov.operacao = 'debito')

	-- Calculo do total de transferências
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
	       FORMAT(@Credito, 'C', 'pt-br') AS 'Total de Crédito',
		   FORMAT(@Debito, 'C', 'pt-br') AS 'Total de Débito',
		   FORMAT(@Transferencia, 'C', 'pt-br') AS 'Total de Tranferência',
		   FORMAT(@Credito - (@Debito + @Transferencia), 'C', 'pt-br') AS 'Saldo'
	FROM Conta AS Con
	INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta
	WHERE Con.codigo = 1

	-- Apresentando o resultado como Mensagem
	/* Com CAST
	PRINT 'Total de Crédito: ' + CAST(@Credito AS VARCHAR)
	PRINT 'Total de Débito: ' + CAST(@Debito AS VARCHAR)
	PRINT 'Total de Tranferência: ' + CAST(@Tranferencia AS VARCHAR)
	PRINT 'Saldo: ' + CAST(@Credito - (@Debito + @Transferencia) AS VARCHAR) */

	-- Com FORMAT
	PRINT 'Total de Crédito: ' + FORMAT(@Credito, 'C', 'pt-br')
	PRINT 'Total de Débito: ' + FORMAT(@Debito, 'C', 'pt-br')
	PRINT 'Total de Tranferência: ' + FORMAT(@Tranferencia, 'C', 'pt-br')
	PRINT 'Saldo: ' + FORMAT(@Credito - (@Debito + @Transferencia), 'C', 'pt-br')

END -- Fim do bloco
GO



-- Retirar valores fixos para possibilitar reuso

BEGIN -- Início do bloco

	-- Variáves
	DECLARE @Conta INT = 1,
	        @Credito SMALLMONEY,
	        @Debito SMALLMONEY,
	        @Transferencia SMALLMONEY

	-- Calculo do total de crédito
	SET @Credito = (SELECT SUM(Mov.valor)
					FROM Conta AS Con
					INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta
					INNER JOIN Movimentacao AS Mov ON Car.codigo = Mov.codigoCartao
					WHERE Con.codigo = @Conta AND Mov.operacao = 'credito')

    -- Calculo do total de dédito
	SET @Debito = (SELECT SUM(Mov.valor)
					FROM Conta AS Con
					INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta
					INNER JOIN Movimentacao AS Mov ON Car.codigo = Mov.codigoCartao
					WHERE Con.codigo = @Conta AND Mov.operacao = 'debito')

	-- Calculo do total de transferências
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
	       FORMAT(@Credito, 'C', 'pt-br') AS 'Total de Crédito',
		   FORMAT(@Debito, 'C', 'pt-br') AS 'Total de Débito',
		   FORMAT(@Transferencia, 'C', 'pt-br') AS 'Total de Tranferência',
		   FORMAT(@Credito - (@Debito + @Transferencia), 'C', 'pt-br') AS 'Saldo'
	FROM Conta AS Con
	-- INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta
	WHERE Con.codigo = @Conta

	-- Consulta completa (resultado em mensagens)
	PRINT 'Total de Crédito: ' + FORMAT(@Credito, 'C', 'pt-br')
	PRINT 'Total de Débito: ' + FORMAT(@Debito, 'C', 'pt-br')
	PRINT 'Total de Tranferência: ' + FORMAT(@Transferencia, 'C', 'pt-br')
	PRINT 'Saldo: ' + FORMAT(@Credito - (@Debito + @Transferencia), 'C', 'pt-br')

END -- Fim do bloco
GO


--------------------------------------------------------------------------------------
-- Inserção que impacta mais de uma tabela

-- Inseção de Cliente Pessoa Física


SELECT * 
FROM Cliente AS Cli
INNER JOIN ClientePF AS PF ON Cli.codigo = PF.codigoCliente

-- Inserção do endereço
-- Recuperar o código do novo endereço
-- Inserir os dados em Cliente
-- Recuperar o código (chave primária) gerada
-- Alterar o nome do arquivos da foto (reutiliza o código do Cliente)
-- Inserir os dados em ClientePF

SELECT * FROM Endereco
SELECT * FROM Cliente
SELECT * FROM ClientePF

BEGIN
	-- Declarações de variáveis
	DECLARE @CodigoEndereco INT,
			@Logradouro VARCHAR(100) = 'José Bonifácio, 123',
			@Bairro VARCHAR(75) = 'Santo Antônio',
			@Cidade VARCHAR(75) = 'Palmas',
			@Uf CHAR(2) = 'TO',
			@Cep CHAR(10) = '78889-396',
			@CodigoCliente INT,
			@Nome VARCHAR(100) = 'Alucinética Campos Costa',
			@NomeSocial VARCHAR(100) = 'Fernanda Campos Costa',
			@Foto VARCHAR(100) = '',
			@DataNasc DATE = '19/04/1986',
			@Usuario CHAR(10) = 'fer',
			@Senha INT = 468798,
			@Cpf VARCHAR(15) = '38827761101',
			@Rg VARCHAR(15) = 'TO-58.407.391'

	-- Inserção do endereço
	INSERT INTO Endereco
	VALUES(@Logradouro, @Bairro, @Cidade, @Uf, @Cep)

	-- Recuperação do código gerado para o endereço
	SET @CodigoEndereco = (SELECT MAX(codigo) FROM Endereco)

	-- Inserção do cliente (generalização)
	INSERT INTO Cliente
	VALUES(@CodigoEndereco, @Nome, @NomeSocial, @Foto, @DataNasc, @Usuario, @Senha)

	-- Recuperação do código gerado para o cliente
	SELECT @CodigoCliente = MAX(codigo)
	FROM Cliente

	-- Alteração do caminho\nome da foto (reutilizando o código do cliente)
	UPDATE Cliente
	SET foto_logo = CONCAT('\fotos\',@CodigoCliente,'.jpg')
	WHERE codigo = @CodigoCliente

	-- Inserção do ClientePF (especialização)
	INSERT INTO ClientePF
	VALUES(@CodigoCliente, @Cpf, @Rg)

	-- Verificação dos resultados
	SELECT * 
	FROM Cliente AS Cli
	INNER JOIN ClientePF AS PF ON Cli.codigo = PF.codigoCliente
	INNER JOIN Endereco AS E ON Cli.codigoEndereco = E.codigo
	WHERE Cli.codigo = @CodigoCliente

END
GO


-- Nova inserção

BEGIN
	-- Declarações de variáveis
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

	-- Inserção do endereço
	INSERT INTO Endereco
	VALUES(@Logradouro, @Bairro, @Cidade, @Uf, @Cep)

	-- Recuperação do código gerado para o endereço
	SET @CodigoEndereco = (SELECT MAX(codigo) FROM Endereco)

	-- Inserção do cliente (generalização)
	INSERT INTO Cliente
	VALUES(@CodigoEndereco, @Nome, @NomeSocial, @Foto, @DataNasc, @Usuario, @Senha)

	-- Recuperação do código gerado para o cliente
	SELECT @CodigoCliente = MAX(codigo)
	FROM Cliente

	-- Alteração do caminho\nome da foto (reutilizando o código do cliente)
	UPDATE Cliente
	SET foto_logo = CONCAT('\fotos\',@CodigoCliente,'.jpg')
	WHERE codigo = @CodigoCliente

	-- Inserção do ClientePF (especialização)
	INSERT INTO ClientePF
	VALUES(@CodigoCliente, @Cpf, @Rg)

	-- Verificação dos resultados
	SELECT * 
	FROM Cliente AS Cli
	INNER JOIN ClientePF AS PF ON Cli.codigo = PF.codigoCliente
	INNER JOIN Endereco AS E ON Cli.codigoEndereco = E.codigo
	WHERE Cli.codigo = @CodigoCliente

END
GO