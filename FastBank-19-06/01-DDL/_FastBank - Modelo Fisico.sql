/*-------------------------------------------
Banco: FastBank
Autor: Ralfe
Última alteração: 14/06/2023 - 21:00
Descrição: Modelo Conceitual (Script de DDL)
           Objetos do Banco
--------------------------------------------*/
/* Documentação:

	Exibição de informações do catálogo do sistema com metadados de cada tabela
    https://learn.microsoft.com/pt-br/sql/relational-databases/tables/view-the-table-definition
*/


-- Criação do Banco
CREATE DATABASE FastBank
GO

-- Conexão com o Banco
USE Fastbank
GO

-- Tabelas que não possuem chave estrangeira

CREATE TABLE Conta(
	codigo INT IDENTITY,	
	agencia VARCHAR(15) NOT NULL,
	numero VARCHAR(25) NOT NULL,
	tipo VARCHAR(30) NOT NULL,
	limite SMALLMONEY NOT NULL,
	ativa BIT NOT NULL,
	CONSTRAINT PK_Conta PRIMARY KEY(codigo),
	CONSTRAINT CHK_Conta_tipo CHECK (tipo = 'corrente' OR tipo = 'investimento')
)
GO

CREATE TABLE Endereco(
	codigo INT IDENTITY,
	logradouro VARCHAR(100) NOT NULL,
	bairro VARCHAR(75) NOT NULL,
	cidade VARCHAR(75) NOT NULL,
	uf CHAR(2) NOT NULL,
	cep CHAR(10) NOT NULL,
	CONSTRAINT PK_Endereco PRIMARY KEY(codigo)
)
GO

-- Nas tabelas com chave estrangeira criar primeiro a tabela 
-- com a respectiva chave primária relacionada

CREATE TABLE Cliente(
	codigo INT IDENTITY,
	codigoEndereco INT NOT NULL,
	nome_razaoSocial VARCHAR(100) NOT NULL,
	nomeSocial_fantasia VARCHAR(100),
	foto_logo VARCHAR(100) NOT NULL,
	dataNascimento_abertura DATE NOT NULL,
	usuario CHAR(10) NOT NULL,
	senha INT  NOT NULL,
	CONSTRAINT PK_Cliente PRIMARY KEY(codigo),
	CONSTRAINT UK_Cliente_usuario UNIQUE(usuario),
	CONSTRAINT FK_Cliente_Endereco FOREIGN KEY(codigoEndereco) REFERENCES Endereco(codigo)
)
GO

CREATE TABLE Contato(
	codigo INT IDENTITY,
	codigoCliente INT NOT NULL,
	numero VARCHAR(15) NOT NULL,
	ramal VARCHAR(25),
	email VARCHAR(50),
	observacao VARCHAR(50),
	CONSTRAINT PK_Contato PRIMARY KEY(codigo),
	CONSTRAINT FK_Contato_Cliente FOREIGN KEY(codigoCliente) 
	                              REFERENCES Cliente(codigo)
								  ON UPDATE CASCADE
								  ON DELETE CASCADE
)
GO

CREATE TABLE ClientePF(
	codigoCliente INT,
	cpf VARCHAR(15) NOT NULL,
	rg VARCHAR(15) NOT NULL,
	CONSTRAINT PK_ClientePF PRIMARY KEY(codigoCliente),
	CONSTRAINT UK_ClientePF UNIQUE(cpf, rg),
	CONSTRAINT FK_ClientePF_Cliente FOREIGN KEY(codigoCliente) REFERENCES Cliente(codigo)
)
GO

CREATE TABLE ClientePJ(
	codigoCliente INT,
	cnpj VARCHAR(15) NOT NULL,
	inscricaoMunicipal VARCHAR(30) NOT NULL,
	inscricaoEstadual VARCHAR(30),
	CONSTRAINT PK_ClientePJ PRIMARY KEY(codigoCliente),
	CONSTRAINT UK_ClientePJ_cnpj UNIQUE(cnpj),
	CONSTRAINT UK_ClientePJ_im UNIQUE(inscricaoMunicipal),
	CONSTRAINT FK_ClientePJ_Cliente FOREIGN KEY(codigoCliente) REFERENCES Cliente(codigo)
)
GO

CREATE TABLE Cartao(
	codigo INT IDENTITY,
	codigoConta INT NOT NULL,
	numero VARCHAR(30) NOT NULL,
	cvv VARCHAR(5) NOT NULL,
	validade DATE NOT NULL,
	bandeira VARCHAR(20) NOT NULL,
	situacao VARCHAR(20) NOT NULL,
	CONSTRAINT PK_Cartao PRIMARY KEY(codigo),
	CONSTRAINT UK_Cartao_numero UNIQUE(numero),
	CONSTRAINT CHK_Cartao_situacao CHECK (situacao = 'bloqueado' OR situacao = 'ativo' OR situacao = 'vencido'),
	CONSTRAINT FK_Cartao_Conta FOREIGN KEY(codigoConta) REFERENCES Conta(codigo)
)
GO

CREATE TABLE Movimentacao(
	codigo INT IDENTITY,
	codigoCartao INT NOT NULL,
	codigoContaDestino INT,
	dataHora DATETIME NOT NULL,
	operacao VARCHAR(20) NOT NULL,
	valor SMALLMONEY NOT NULL,
	CONSTRAINT PK_Movimentacao PRIMARY KEY(codigo),
	CONSTRAINT CHK_Movimentacao_operacao CHECK (operacao = 'debito' 
	                                         OR operacao = 'credito' 
								             OR operacao = 'transferencia'),
	CONSTRAINT FK_Movimentacao_Cartao FOREIGN KEY(codigoCartao) REFERENCES Cartao(codigo),
	CONSTRAINT FK_Movimentacao_Conta FOREIGN KEY(codigoContaDestino) REFERENCES Conta(codigo)
)
GO

CREATE TABLE Emprestimo(
	codigo INT IDENTITY,
	codigoConta INT NOT NULL,
	dataSolicitacao DATE NOT NULL,
	valorSolicitado SMALLMONEY NOT NULL,
	juros FLOAT NOT NULL,
	aprovado BIT NOT NULL,
	numeroParcela INT,
	dataAprovacao DATE,
	observacao VARCHAR(20),
	CONSTRAINT PK_Emprestimo PRIMARY KEY(codigo),
	CONSTRAINT FK_Emprestimo_Conta FOREIGN KEY(codigoConta) REFERENCES Conta(codigo)
)
GO

CREATE TABLE EmprestimoParcela(
	codigo INT IDENTITY,
	codigoEmprestimo INT NOT NULL,
	numero INT NOT NULL,
	dataVencimento DATE NOT NULL,
	valorParcela SMALLMONEY NOT NULL,
	dataPagamento DATE,
	valorPago SMALLMONEY,
	CONSTRAINT PK_EmprestimoParcela PRIMARY KEY(codigo),
	CONSTRAINT FK_EmprestimoParcela_Emprestimo FOREIGN KEY(codigoEmprestimo) 
	                                           REFERENCES Emprestimo(codigo)
)
GO

CREATE TABLE Investimento(
	codigo INT IDENTITY,
	codigoConta INT NOT NULL,
	tipo VARCHAR(30) NOT NULL,
	aporte SMALLMONEY NOT NULL,
	taxaAdministracao FLOAT NOT NULL,
	prazo VARCHAR(20) NOT NULL,
	grauRisco CHAR(5) NOT NULL,
	rentabilidade SMALLMONEY,
	finalizado BIT NOT NULL,
	CONSTRAINT PK_Investimento PRIMARY KEY(codigo),
	CONSTRAINT CHK_Investimento_prazo CHECK (prazo = 'curto' OR prazo = 'medio' OR prazo = 'longo'),
	CONSTRAINT FK_Investimento_Conta FOREIGN KEY(codigoConta) REFERENCES Conta(codigo)
)
GO

CREATE TABLE ClienteConta(
	codigoCliente INT,
	codigoConta INT,
	CONSTRAINT PK_ClienteConta PRIMARY KEY(codigoCliente, codigoConta),
	CONSTRAINT FK_ClienteConta_Cliente FOREIGN KEY(codigoCliente) REFERENCES Cliente(codigo),
	CONSTRAINT FK_ClienteConta_Conta FOREIGN KEY(codigoConta) REFERENCES Conta(codigo)
)
GO

-- Alterações em tabelas

ALTER TABLE Conta
ADD saldo SMALLMONEY
GO

UPDATE Conta
SET saldo = 0
GO

ALTER TABLE Movimentacao
ADD estorno BIT
GO

UPDATE Movimentacao
SET estorno = 0
GO

-- Objetos do Banco

-- VIEW

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


-- FUNCTION

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
			SET @Retorno = 'Cliente não encontrado!'
		END
	
	RETURN @Retorno
END
GO


CREATE OR ALTER FUNCTION fnCreditoConta(@Conta INT) RETURNS SMALLMONEY
AS
BEGIN
	-- Calculo do total de crédito
	RETURN (SELECT SUM(Mov.valor)
			FROM Conta AS Con
			INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta
			INNER JOIN Movimentacao AS Mov ON Car.codigo = Mov.codigoCartao
			WHERE Con.codigo = @Conta AND Mov.operacao = 'credito')
END
GO


CREATE OR ALTER FUNCTION fnDebitoConta(@Conta INT) RETURNS SMALLMONEY
AS
BEGIN
	-- Calculo do total de crédito
	RETURN (SELECT SUM(Mov.valor)
			FROM Conta AS Con
			INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta
			INNER JOIN Movimentacao AS Mov ON Car.codigo = Mov.codigoCartao
			WHERE Con.codigo = @Conta AND Mov.operacao = 'debito')
END
GO


CREATE OR ALTER FUNCTION fnTransferenciaConta(@Conta INT) RETURNS SMALLMONEY
AS
BEGIN
	-- Calculo do total de crédito
	RETURN (SELECT SUM(Mov.valor)
			FROM Conta AS Con
			INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta
			INNER JOIN Movimentacao AS Mov ON Car.codigo = Mov.codigoCartao
			WHERE Con.codigo = @Conta AND Mov.operacao = 'transferencia')
END
GO


CREATE OR ALTER FUNCTION fnConexaoSessao(@SessaoID INT) RETURNS VARCHAR(MAX)
AS
BEGIN
	
	DECLARE @Banco VARCHAR(50),
	        @Sessao VARCHAR(50),
	        @Login VARCHAR(50),
			@Maquina VARCHAR(50),
			@Software VARCHAR(100),
			@Inicio VARCHAR(50),
			@Ip VARCHAR(50)

	SELECT @Banco = DB_NAME(),
		   @Sessao = Sessao.session_id,
		   @Login = Sessao.login_name,
		   @Maquina = Sessao.host_name,
		   @Software = Sessao.program_name,
		   @Inicio = CAST(Conexao.connect_time AS VARCHAR(25)),
		   @Ip = Conexao.client_net_address
	FROM sys.dm_exec_connections AS Conexao
	INNER JOIN sys.dm_exec_sessions AS Sessao ON Conexao.session_id = Sessao.session_id
	WHERE Conexao.session_id = @SessaoID

	RETURN FORMATMESSAGE('Banco: %s, Sessão: %s, Login: %s, Máquina: %s, @Software: %s, Início: %s. IP: %s',
	                      @Banco, @Sessao, @Login, @Maquina, @Software, @Inicio, @Ip)
END
GO



-- TYPE

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
	Ativa BIT,
	Saldo SMALLMONEY
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

CREATE TYPE tpParcelasEmprestimo AS TABLE(
	numero INT,	
	valor SMALLMONEY,
	venvimento DATE
)
GO

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


-- SEQUENCE

CREATE SEQUENCE CodigoLogErros
AS INT
START WITH 1
INCREMENT BY 1  
GO


-- Tabela

CREATE TABLE LogErros(
	codigo INT DEFAULT NEXT VALUE FOR CodigoLogErros,
	dataHora DATETIME DEFAULT GETDATE(),
	detalhamento VARCHAR(MAX),
	CONSTRAINT PK_LogErros PRIMARY KEY (codigo)
) 
GO



-- STORED PROCEDURE

CREATE OR ALTER PROCEDURE stpMovimentacaoConta
	@Conta INT -- parâmetro de Valor Escalar (um dado)
AS
BEGIN
	-- Variáves recebendo retornos de funções
	DECLARE @Credito SMALLMONEY = (SELECT dbo.fnCreditoConta(@Conta)),
	        @Debito SMALLMONEY = (SELECT dbo.fnDebitoConta(@Conta)),
	        @Transferencia SMALLMONEY  = (SELECT dbo.fnTransferenciaConta(@Conta))

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
END
GO


CREATE OR ALTER PROCEDURE stpNovoEmprestimo
	@Emprestimo tpEmprestimo READONLY -- parâmetro de Valor de Tabela (conjunto de dados)
AS
BEGIN
	-- Declaração de variáveis
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

	-- Armazena os valores recebidos pelo parâmetro @Emprestimo em variáveis
	SELECT @CodigoConta = codigoConta,
		   @DataSolicitacao = dataSolicitacao,
		   @ValorSolicitado = valorSolicitado,
		   @Juros = juros,
		   @Aprovado = aprovado,
		   @NumeroParcela = numeroParcela,
		   @DataAprovacao = dataAprovacao,
		   @Observarcao = observarcao
	FROM @Emprestimo
	
	-- Inserção em Emprestimo
	INSERT INTO Emprestimo
	VALUES(@CodigoConta, @DataSolicitacao, @ValorSolicitado, @Juros, @Aprovado, @NumeroParcela, @DataAprovacao, @Observarcao)

	-- Recuperação do código do emprestimo gerado
	SET @CodigoEmprestimo = @@IDENTITY

	-- Calculo do valores das parcelas
	SET @ValorParcela = @ValorSolicitado / @NumeroParcela

	-- Calculo do vencimento da primeira parcela
	SET @DataVencimento = DATEADD(MONTH, 1, @DataAprovacao)

	-- Looping para inserção de quantas parcelas forem necessárias 
	-- de acordo com o número de parcelas
	WHILE(@Numero <= @NumeroParcela)
		BEGIN	
			-- Inserção de cada parcela
			INSERT INTO EmprestimoParcela
			VALUES(@CodigoEmprestimo, @Numero, @DataVencimento, @ValorParcela, @DataPagamento, @ValorPago)

			-- Calculo do vencimento da próxima parcela 
			SET @DataVencimento = DATEADD(MONTH, 1, @DataVencimento)

			-- Numeros da próxima parcela
			SET @Numero = @Numero + 1
		END
END
GO


CREATE OR ALTER PROCEDURE stpNovoEmprestimo
	@Emprestimo tpEmprestimo READONLY -- parâmetro de Valor de Tabela (conjunto de dados)
AS
BEGIN
	-- Declaração de variáveis
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

	-- Armazena os valores recebidos pelo parâmetro @Emprestimo em variáveis
	SELECT @CodigoConta = codigoConta,
		   @DataSolicitacao = dataSolicitacao,
		   @ValorSolicitado = valorSolicitado,
		   @Juros = juros,
		   @Aprovado = aprovado,
		   @NumeroParcela = numeroParcela,
		   @DataAprovacao = dataAprovacao,
		   @Observarcao = observarcao
	FROM @Emprestimo
	
	-- Inserção em Emprestimo
	INSERT INTO Emprestimo
	VALUES(@CodigoConta, @DataSolicitacao, @ValorSolicitado, @Juros, @Aprovado, @NumeroParcela, @DataAprovacao, @Observarcao)

	-- Recuperação do código do emprestimo gerado
	SET @CodigoEmprestimo = @@IDENTITY

	-- Calculo do valores das parcelas
	SET @ValorParcela = @ValorSolicitado / @NumeroParcela

	-- Calculo do vencimento da primeira parcela
	SET @DataVencimento = DATEADD(MONTH, 1, @DataAprovacao)

	-- Looping para inserção de quantas parcelas forem necessárias 
	-- de acordo com o número de parcelas
	WHILE(@Numero <= @NumeroParcela)
		BEGIN
		
			-- Inserção de cada parcela
			INSERT INTO EmprestimoParcela
			VALUES(@CodigoEmprestimo, @Numero, @DataVencimento, @ValorParcela, @DataPagamento, @ValorPago)

			-- Calculo do vencimento da próxima parcela 
			SET @DataVencimento = DATEADD(MONTH, 1, @DataVencimento)

			-- Numeros da próxima parcela
			SET @Numero = @Numero + 1
		END
END
GO


CREATE OR ALTER PROCEDURE stpNovoCliente
	@Endereco tpEndereco READONLY,  -- parâmetros de Valores de Tabelas (conjuntos de dados)
	@ClientePF tpClientePF READONLY,
	@Contato tpContato READONLY,
	@Conta tpConta READONLY,
	@Cartao tpCartao READONLY
AS
BEGIN
	--Declaração de variáveis
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
			@Saldo SMALLMONEY,
			-- Cartao 
			@NumeroCartao VARCHAR(30), 
			@Cvv CHAR(5), 
			@Validade DATE, 
			@Bandeira VARCHAR(20), 
			@Situacao VARCHAR(20)

	-- Armazena os valores recebidos pelo parâmetro @Endereco em variáveis
	SELECT @Logradouro = Logradouro, 
		   @Bairro = Bairro,
		   @Cidade = Cidade,
		   @Uf = Uf,
		   @Cep = Cep
	FROM @Endereco

	-- Armazena os valores recebidos pelo parâmetro @ClientePF em variáveis
	SELECT @NomeRazao = NomeRazao,
		   @NomeSocialFantasia = NomeSocialFantasia,
		   @Foto = Foto,
		   @DataNascAbertura = DataNascAbertura,
		   @Usuario = Usuario, 
		   @Senha = Senha,
		   @Cpf = Cpf, 			
		   @Rg = Rg
	FROM @ClientePF

	-- Armazena os valores recebidos pelo parâmetro @Contato em variáveis
	SELECT @NumeroTelefone = NumeroTelefone, 
		   @Ramal = Ramal,
		   @Email = Email,
		   @Observacao = Observacao
	FROM @Contato

	-- Armazena os valores recebidos pelo parâmetro @Conta em variáveis
	SELECT @Agencia = Agencia, 			
		   @NumeroConta = NumeroConta,
		   @Tipo = Tipo,
		   @Limite = Limite,
		   @Ativa = Ativa,
		   @Saldo = Saldo
	FROM @Conta

	-- Armazena os valores recebidos pelo parâmetro @Cartao em variáveis
	SELECT @NumeroCartao = NumeroCartao, 			
		   @Cvv = Cvv,
		   @Validade = Validade,
		   @Bandeira = Bandeira, 
		   @Situacao = Situacao
	FROM @Cartao

	-- Inserção do endereço
	INSERT INTO Endereco
	VALUES(@Logradouro, @Bairro, @Cidade, @Uf, @Cep)
	-- Recuperação do codigo gerado
	SET @CodigoEndereco = @@IDENTITY

	-- Inserção do Cliente (generalização)
	INSERT INTO Cliente
	VALUES(@CodigoEndereco, @NomeRazao, @NomeSocialFantasia, @Foto, @DataNascAbertura, @Usuario, @Senha)
	-- Recuperação do codigo gerado
	SET @CodigoCliente = @@IDENTITY
	-- Alteração do atributo foto_logo
	UPDATE Cliente
	SET foto_logo = CONCAT('\fotos\',@CodigoCliente,'.jpg')
	WHERE codigo = @CodigoCliente

	-- Inserção do ClientePF (especialização)
	INSERT INTO ClientePF
	VALUES(@CodigoCliente, @Cpf, @Rg)

	-- Inserção do Contato
	INSERT INTO Contato
	VALUES(@CodigoCliente, @NumeroTelefone, @Ramal, @Email, @Observacao)

	-- Inserção da Conta
	INSERT INTO Conta
	VALUES(@Agencia, @NumeroConta, @Tipo, @Limite, @Ativa, @Saldo)
	-- Recuperação do codigo gerado
	SET @CodigoConta = @@IDENTITY

	-- Relacionamento entre Cliente e Conta
	INSERT INTO ClienteConta
	VALUES(@CodigoCliente, @CodigoConta)

	-- Inserção do Cartão
	INSERT INTO Cartao
	VALUES(@CodigoConta, @NumeroCartao, @Cvv, @Validade, @Bandeira, @Situacao)

END
GO


CREATE OR ALTER PROCEDURE stpTotalQuitacaoEmprestimo
	@CodEmprestimo INT,
	@Valor SMALLMONEY OUTPUT -- parâmetro de saída (retorno)
AS
BEGIN
	SELECT @Valor = SUM(Parcela.valorParcela)
	FROM Emprestimo AS E
	INNER JOIN EmprestimoParcela AS Parcela ON E.codigo = Parcela.codigoEmprestimo
	WHERE E.codigo = @CodEmprestimo AND Parcela.valorPago IS NOT NULL
END
GO


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


CREATE OR ALTER PROCEDURE stpNovoEmprestimo
	@Emprestimo tpEmprestimo READONLY
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			-- Declaração de variáveis
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
					@ValorPago SMALLMONEY = NULL,

					@Erro INT

			-- Armazena os valores recebidos pelo parâmetro @Emprestimo em variáveis
			SELECT @CodigoConta = codigoConta,
				   @DataSolicitacao = dataSolicitacao,
				   @ValorSolicitado = valorSolicitado,
				   @Juros = juros,
				   @Aprovado = aprovado,
				   @NumeroParcela = numeroParcela,
				   @DataAprovacao = dataAprovacao,
				   @Observarcao = observarcao
			FROM @Emprestimo
	

			-- Inserção em Emprestimo
			INSERT INTO Emprestimo
			VALUES(@CodigoConta, @DataSolicitacao, @ValorSolicitado, @Juros, @Aprovado, @NumeroParcela, @DataAprovacao, @Observarcao)

			-- Recuperação do código do emprestimo gerado
			-- SET @CodigoEmprestimo = @@IDENTITY

			-- Calculo do valores das parcelas
			SET @ValorParcela = @ValorSolicitado / @NumeroParcela

			-- Calculo do vencimento da primeira parcela
			SET @DataVencimento = DATEADD(MONTH, 1, @DataAprovacao)

			-- Looping para inserção de quantas parcelas forem necessárias 
			-- de acordo com o número de parcelas
			WHILE(@Numero <= @NumeroParcela)
				BEGIN
		
					-- Inserção de cada parcela
					INSERT INTO EmprestimoParcela
					VALUES(@CodigoEmprestimo, @Numero, @DataVencimento, @ValorParcela, @DataPagamento, @ValorPago)

					-- Calculo do vencimento da próxima parcela 
					SET @DataVencimento = DATEADD(MONTH, 1, @DataVencimento)

					-- Numeros da próxima parcela
					SET @Numero = @Numero + 1
				END

		-- Confirma a transação (persiste as alterações dos dados permanentemente)
		COMMIT
	END TRY

	BEGIN CATCH
		-- Recuperando o código do erro
		SET @Erro = @@ERROR
		-- Apresentando em Mensagem
		RAISERROR('Erro: %d', 10, 1, @Erro)

		-- Ignorar e desfazer as alterações realizadas
		ROLLBACK
	END CATCH
END
GO


CREATE OR ALTER PROCEDURE stpNovoEmprestimo
	@Emprestimo tpEmprestimo READONLY
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			-- Declaração de variáveis
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
					@ValorPago SMALLMONEY = NULL,

					@Erro INT

			-- Armazena os valores recebidos pelo parâmetro @Emprestimo em variáveis
			SELECT @CodigoConta = codigoConta,
				   @DataSolicitacao = dataSolicitacao,
				   @ValorSolicitado = valorSolicitado,
				   @Juros = juros,
				   @Aprovado = aprovado,
				   @NumeroParcela = numeroParcela,
				   @DataAprovacao = dataAprovacao,
				   @Observarcao = observarcao
			FROM @Emprestimo
	
			-- Inserção em Emprestimo
			INSERT INTO Emprestimo
			VALUES(@CodigoConta, @DataSolicitacao, @ValorSolicitado, @Juros, @Aprovado, @NumeroParcela, @DataAprovacao, @Observarcao)

			-- Recuperação do código do emprestimo gerado
			-- SET @CodigoEmprestimo = @@IDENTITY

			-- Calculo do valores das parcelas
			SET @ValorParcela = @ValorSolicitado / @NumeroParcela

			-- Calculo do vencimento da primeira parcela
			SET @DataVencimento = DATEADD(MONTH, 1, @DataAprovacao)

			-- Looping para inserção de quantas parcelas forem necessárias 
			-- de acordo com o número de parcelas
			WHILE(@Numero <= @NumeroParcela)
				BEGIN	
					-- Inserção de cada parcela
					INSERT INTO EmprestimoParcela
					VALUES(@CodigoEmprestimo, @Numero, @DataVencimento, @ValorParcela, @DataPagamento, @ValorPago)

					-- Calculo do vencimento da próxima parcela 
					SET @DataVencimento = DATEADD(MONTH, 1, @DataVencimento)

					-- Numeros da próxima parcela
					SET @Numero = @Numero + 1
				END

		-- Confirma a transação (persiste as alterações dos dados permanentemente)
		COMMIT
	END TRY

	BEGIN CATCH
		-- Recuperando o código do erro
		SET @Erro = @@ERROR
		-- Apresentando em Mensagem
		RAISERROR('Erro: %d', 10, 1, @Erro)

		-- Ignorar e desfazer as alterações realizadas
		ROLLBACK
	END CATCH
END
GO


CREATE OR ALTER PROCEDURE stpContaInvestimentoPJ
	@Conta tpConta READONLY,
	@Cartao tpCartao READONLY,	
	@Investimento tpInvestimento READONLY
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

			DECLARE -- Conta
					@Agencia VARCHAR(10),
					@NumeroConta VARCHAR(25),
					@TipoConta VARCHAR(20),
					@Limite SMALLMONEY,
					@Ativa BIT,
					@Saldo SMALLMONEY,
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
					@Finalizado BIT,
					-- Erros
					@Erro INT,
					@MensagemErro VARCHAR(MAX),
					@ErroCompleto VARCHAR(MAX),
					@Severidade INT,
					@Estado INT

			-- Armazena os valores recebidos pelo parâmetro @Conta em variáveis
			SELECT @Agencia = Agencia, 			
					@NumeroConta = NumeroConta,
					@TipoConta = Tipo,
					@Limite = Limite,
					@Ativa = Ativa,
					@Saldo = Saldo
			FROM @Conta

			-- Armazena os valores recebidos pelo parâmetro @Cartao em variáveis
			SELECT @NumeroCartao = NumeroCartao, 			
					@Cvv = Cvv,
					@Validade = Validade,
					@Bandeira = Bandeira, 
					@Situacao = Situacao
			FROM @Cartao

			-- Armazena os valores recebidos pelo parâmetro @Investimento em variáveis
			SELECT @TipoInvestimento = TipoInvestimento,
					@Aporte = Aporte,
					@TaxaAdminstrativa = TaxaAdminstrativa,
					@Prazo = Prazo,
					@Risco = Risco,
					@Rentabilidade = Rentabilidade, 
					@Finalizado = Finalizado
			FROM @Investimento

			-- (gerar um erro caso o aporte seja negativo)
			IF @Aporte < 0
				BEGIN
					-- Gera um objeto de erro (Nível: 16, Estado: 2)
					RAISERROR('O valor do aporte não pode ser negativo!', 16, 2)
				END

			INSERT INTO Conta
			VALUES(@Agencia, @NumeroConta, @TipoConta, @Limite, @Ativa, @Saldo)

			-- (comente essa linha para gerar um erro)
			SET @CodigoConta = @@IDENTITY 

			INSERT INTO Cartao
			VALUES(@CodigoConta, @NumeroCartao, @Cvv, @Validade, @Bandeira, @Situacao)

			INSERT INTO Investimento
			VALUES(@CodigoConta, @TipoInvestimento, @Aporte, @TaxaAdminstrativa, @Prazo, @Risco, @Rentabilidade, @Finalizado)

		COMMIT

	END TRY

	BEGIN CATCH
		-- Recuperando o código do erro
		SET @Erro = @@ERROR
		-- Tratamento específico para o erro 515 (gerado pelo SQL Server)
		IF @Erro = 515
			BEGIN
				SET @MensagemErro = FORMATMESSAGE('Erro: %d, Mensagem padrão: %s, Severidade: %d, Mensagem especifica: %s',
				                                  @Erro, ERROR_MESSAGE(), ERROR_SEVERITY(), 'Código da conta inválido!')
			END
		-- Tratamento específico para o erro 50000 (gerado pelo RAISERROR)
		ELSE IF @Erro = 50000
			BEGIN
				SET @MensagemErro = FORMATMESSAGE('Erro: %d, Mensagem padrão: %s, Severidade: %d',
				                                  @Erro, ERROR_MESSAGE(), ERROR_SEVERITY())
			END
		ELSE
			-- Identificação de erros imprevistos
			BEGIN
				SET @MensagemErro = FORMATMESSAGE('Erro: %d, Mensagem padrão: %s, Severidade: %d, Estado: %d, Linha: %d, Mensagem especifica: %s',
				                                  ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_LINE(),
												  'Erro imprevisto!')
			END

		-- Geração da Mensagem de Erro Completa que consiste na junção da 
		-- mensagem de erro (detalhes do erro) com os dados da conexão e sessão (retorno da função fnConexaoSessao)
		SET @ErroCompleto = CONCAT(@MensagemErro,' - ', dbo.fnConexaoSessao(@@SPID))

		-- Ignorar e desfazer as alterações realizadas
		ROLLBACK

		-- Recupera a Severidade e Estado gerados no erro
		SET @Severidade = ERROR_SEVERITY()
		SET @Estado = ERROR_STATE()
		-- Insere o erro no log so SQL Server
		RAISERROR('%s', @Severidade, @Estado, @ErroCompleto) WITH LOG

		-- Insere o erro na tabela de log interna
		INSERT INTO LogErros (detalhamento)
		VALUES (@ErroCompleto)

	END CATCH
END
GO


CREATE OR ALTER PROCEDURE stpMovimentacaoContaXML
	@Conta INT,                 -- parâmetro de Valor Escalar (um dado)
	@MovimentacaoXML XML OUTPUT -- parâmetro de saída 	
AS
BEGIN
	-- Variáves recebendo retornos de funções
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


CREATE OR ALTER PROCEDURE stpMovimentacaoContaJSON
	@Conta INT,                           -- parâmetro de Valor Escalar (um dado)
	@MovimentacaoJSON VARCHAR(MAX) OUTPUT -- parâmetro de saída 	
AS
BEGIN
	-- Variáves recebendo retornos de funções
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


--TRIGGER


CREATE OR ALTER TRIGGER trgAtualizarSaldo
ON Movimentacao
AFTER INSERT AS
BEGIN
	DECLARE @CodigoConta INT,
	        @CodigoCartao INT,
			@Operacao VARCHAR(25),
			@Valor SMALLMONEY
	
	-- Recupera das da ultima inserção em Movimentacao
	SELECT @CodigoCartao = CodigoCartao,
	       @Operacao = Operacao,
		   @Valor = Valor
	FROM inserted

	-- Obtém a Conta
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
GO


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

	-- Recupera das da ultima inserção em Movimentacao
	SELECT @CodigoMovimentacao = codigo,
	       @CodigoCartao = codigoCartao,
		   @Operacao = operacao,
		   @Valor = valor,
		   @Estorno = estorno
	FROM deleted

	IF(@Estorno = 0)
		BEGIN
			-- Obtém a Conta
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

			-- Executa a alteração (EM VEZ DA instrução que "disparou" a trigger)
			UPDATE Movimentacao
			SET estorno = 1
			WHERE codigo = @CodigoMovimentacao
		END
	ELSE
		PRINT 'Movimentação já estornada!'
END
GO


