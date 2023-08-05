/*----------------------------------------------------
Banco: FastBank
Autor: Ralfe
Última alteração: 16/03/2023 - 21:45 - Ralfe
Descrição: Criação do banco e das tabelas e restrições
-----------------------------------------------------*/
/* Documentação:

	CONSTRAINT
	https://learn.microsoft.com/pt-br/sql/relational-databases/system-information-schema-views/table-constraints-transact-sql

	PRIMARY e FOREIGN KEY
	https://learn.microsoft.com/pt-br/sql/relational-databases/tables/primary-and-foreign-key-constraints

	IDENTITY
	https://learn.microsoft.com/pt-br/sql/t-sql/statements/create-table-transact-sql
*/


-- Criação do Banco
CREATE DATABASE FastBank
GO

-- Conexão com o Banco
USE Fastbank
GO

-- Criação das tabelas com suas respectivas restrições (constraints)
CREATE TABLE Cliente(
	codigo INT IDENTITY,
	nome_razaoSocial VARCHAR(100) NOT NULL,
	nomeSocial_fantasia VARCHAR(100),
	foto_logo VARCHAR(100) NOT NULL,
	dataNascimento_abertura DATE NOT NULL,
	usuario CHAR(10) NOT NULL,
	senha INT  NOT NULL,
	CONSTRAINT PK_Cliente PRIMARY KEY(codigo),
	CONSTRAINT UK_Cliente_usuario UNIQUE(usuario)
)
GO


CREATE TABLE Contato(
	codigo INT IDENTITY,
	numero VARCHAR(15) NOT NULL,
	ramal VARCHAR(25),
	email VARCHAR(50),
	observacao VARCHAR(50),
	CONSTRAINT PK_Contato PRIMARY KEY(codigo)
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


CREATE TABLE ClientePF(
	codigo INT,
	cpf VARCHAR(15) NOT NULL,
	rg VARCHAR(15) NOT NULL,
	CONSTRAINT PK_ClientePF PRIMARY KEY(codigo),
	CONSTRAINT UK_ClientePF_cpf UNIQUE(cpf),
	CONSTRAINT UK_ClientePF_rg UNIQUE(rg)
)
GO


CREATE TABLE ClientePJ(
	codigo INT,
	cnpj VARCHAR(15) NOT NULL,
	inscricaoMunicipal VARCHAR(30) NOT NULL,
	inscricaoEstadual VARCHAR(30),
	CONSTRAINT PK_ClientePJ PRIMARY KEY(codigo),
	CONSTRAINT UK_ClientePJ_cnpj UNIQUE(cnpj),
	CONSTRAINT UK_ClientePJ_im UNIQUE(inscricaoMunicipal)
)
GO


CREATE TABLE Conta(
	codigo INT IDENTITY,
	agencia VARCHAR(15) NOT NULL,
	numero VARCHAR(25) NOT NULL,
	tipo VARCHAR(30) NOT NULL,
	limite SMALLMONEY NOT NULL,
	ativa BIT NOT NULL,
	CONSTRAINT PK_Conta PRIMARY KEY(codigo),
	CONSTRAINT CHK_Conta_tipo CHECK (tipo = 'corrente' 
	                              OR tipo = 'investimento')
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
	CONSTRAINT FK_Cartao_Conta FOREIGN KEY(codigoConta) 
	                           REFERENCES Conta(codigo)
)
GO


CREATE TABLE Movimentacao(
	codigo INT IDENTITY,
	dataHora DATETIME NOT NULL,
	operacao VARCHAR(20) NOT NULL,
	valor SMALLMONEY NOT NULL,
	CONSTRAINT PK_Movimentacao PRIMARY KEY(codigo),
	CONSTRAINT CHK_Movimentacao_operacao CHECK (operacao = 'debito' 
	                                         OR operacao = 'credito' 
								             OR operacao = 'transferencia')
)
GO


CREATE TABLE Investimento(
	codigo INT IDENTITY,
	tipo VARCHAR(30) NOT NULL,
	aporte SMALLMONEY NOT NULL,
	taxaAdministracao FLOAT NOT NULL,
	prazo VARCHAR(20) NOT NULL,
	grauRisco CHAR(5) NOT NULL,
	rentabilidade SMALLMONEY,
	finalizado BIT NOT NULL,
	CONSTRAINT PK_Investimento PRIMARY KEY(codigo)
)
GO


CREATE TABLE Emprestimo(
	codigo INT IDENTITY,
	dataSolicitacao DATE NOT NULL,
	valorSolicitado SMALLMONEY NOT NULL,
	juros FLOAT NOT NULL,
	aprovado BIT NOT NULL,
	numeroParcela INT,
	dataAprovacao DATE,
	observacao VARCHAR(20),
	CONSTRAINT PK_Emprestimo PRIMARY KEY(codigo)
)
GO


CREATE TABLE EmprestimoParcela(
	codigo INT IDENTITY,
	numero INT NOT NULL,
	dataVencimento DATE NOT NULL,
	valorParcela SMALLMONEY NOT NULL,
	dataPagamento DATE,
	valorPago SMALLMONEY,
	CONSTRAINT PK_EmprestimoParcela PRIMARY KEY(codigo)
)
GO