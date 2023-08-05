/*-------------------------------------------------------------------
Banco: FastBank
Autor: Ralfe
Última alteração: 16/03/2023 - 19:30 - Ralfe
Descrição: Testes de criação, alteração e exclusão de bancos e tabelas
--------------------------------------------------------------------*/
/* Documentação:

	CREATE DATABASE
	https://learn.microsoft.com/pt-br/sql/t-sql/statements/create-database-transact-sql

	ALTER DATABASE
	https://learn.microsoft.com/pt-br/sql/t-sql/statements/alter-database-transact-sql

	CREATE TABLE
	https://learn.microsoft.com/pt-br/sql/t-sql/statements/create-table-transact-sql

	ALTER TABLE
	https://learn.microsoft.com/pt-br/sql/t-sql/statements/alter-table-transact-sql

	DROP TABLE
	https://learn.microsoft.com/pt-br/sql/t-sql/statements/drop-table-transact-sql
*/

-- Criação do banco
CREATE DATABASE FastBank
GO

-- Exclui um banco
-- DROP DATABASE FastBank

-- Conexão ao banco
USE FastBank
GO

-- Criações das tabelas
CREATE TABLE Cliente (
	nome VARCHAR(100),
	nomeSocial VARCHAR(100),
	foto VARCHAR(100),
	dataNascimento DATE,
	usuario CHAR(10),
	senha INT
)
GO

-- Adicionar uma coluna (atributo)
ALTER TABLE Cliente
ADD codigo INT
GO

-- Alterar uma coluna existente
ALTER TABLE Cliente
ALTER COLUMN foto VARCHAR(125)
GO

-- Renomear um atributo
EXEC sp_rename 'Cliente.nome', 'nome_razaoSocial'
-- Cuidado: a alteração de qualquer parte de um nome de objeto pode interromper scripts e procedimentos armazenados.

-- Excluir um atributo
ALTER TABLE Cliente
DROP COLUMN dataNascimento
GO

-- Exclusão de tabela
DROP TABLE Cliente
GO