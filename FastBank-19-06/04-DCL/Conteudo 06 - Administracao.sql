/*------------------------------------------------------
Banco: FastBank
Autor: Ralfe
Última alteração: 19/06/2023 - 20:00
Descrição: Administração de Banco de Dados
-------------------------------------------------------*/
/* Documentação:
	Paginas de dados
	Plano de execução
		Estatísticas
		SqlQueryStress
	Índices
	Controle de permissões
	Backup e Restore
*/

USE FastBank

SELECT * 
FROM CampeonatoBrasileiro

-- Alocação em memória 
SELECT B.page_type AS 'Tipo de Pagina de Dados', 
       count(B.page_id) AS 'Quantidade de Paginas de Dados', 
	   count(B.page_id) / 128.0 as 'Memoria MB'  
FROM sys.dm_os_buffer_descriptors AS B                                              -- Contém as informações do Buffer 
INNER JOIN sys.allocation_units AS A ON B.allocation_unit_id = A.allocation_unit_id -- Informações de unidade de alocação dos objetos   
INNER JOIN sys.partitions AS P ON A.container_id = P.partition_id                   -- Partições dos objetos de alocação.
WHERE P.object_id = object_id('CampeonatoBrasileiro')  
  AND B.page_type IN ('DATA_PAGE','INDEX_PAGE')
  AND B.database_id = DB_ID()
GROUP BY B.page_type
GO

-- Alocação física dos dados
SELECT ROWS,
       total_pages, 
       used_pages, 
       data_pages , 
       P.data_compression_desc,
	   P.index_id,
	   I.name,
	   I.type_desc
FROM sys.allocation_units AS AU 
INNER JOIN sys.partitions AS P ON AU.container_id = P.partition_id
INNER JOIN sys.indexes AS I ON P.index_id = I.index_id AND P.object_id = I.object_id
WHERE P.object_id = object_id('CampeonatoBrasileiro')
GO

SP_SPACEUSED 'CampeonatoBrasileiro'


---------------------------------------------------------------------------------------------------------
-- Plano de execução
-- https://learn.microsoft.com/pt-br/sql/relational-databases/performance/execution-plans

-- Estatísticas de Consulta
-- https://learn.microsoft.com/pt-br/sql/relational-databases/performance/live-query-statistics

-- Referência de operadores físicos e lógicos de plano de execução
-- https://learn.microsoft.com/pt-br/sql/relational-databases/showplan-logical-and-physical-operators-reference

-- Monitor de Atividade
-- https://learn.microsoft.com/pt-br/sql/relational-databases/performance-monitor/activity-monitor


SET STATISTICS IO ON
SET STATISTICS XML ON

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

SET STATISTICS IO OFF
SET STATISTICS XML OFF

-- STATISTICS IO
/*
Tabela 'Workfile'. 
Contagem de verificações 0, 
leituras lógicas 0, 
leituras físicas 0, 
leituras de servidor de páginas 0, 
leituras antecipadas 0, 
leituras antecipadas de servidor de páginas 0, 
leituras lógicas de LOB 0, 
leituras físicas de LOB 0, 
leituras de servidor de páginas LOB 0, 
leituras antecipadas de LOB 0, 
leituras antecipadas do servidor de páginas LOB 0.

Tabela 'Worktable'. 
Contagem de verificações 0, 
leituras lógicas 0, 
leituras físicas 0, 
leituras de servidor de páginas 0, 
leituras antecipadas 0, 
leituras antecipadas de servidor de páginas 0, 
leituras lógicas de LOB 0, 
leituras físicas de LOB 0, 
leituras de servidor de páginas LOB 0, 
leituras antecipadas de LOB 0, 
leituras antecipadas do servidor de páginas LOB 0.

Tabela 'Cartao'. 
Contagem de verificações 1, 
leituras lógicas 2, 
leituras físicas 1, 
leituras de servidor de páginas 0, 
leituras antecipadas 0, 
leituras antecipadas de servidor de páginas 0, 
leituras lógicas de LOB 0, 
leituras físicas de LOB 0, 
leituras de servidor de páginas LOB 0, 
leituras antecipadas de LOB 0, 
leituras antecipadas do servidor de páginas LOB 0.

Tabela 'ClientePF'. 
Contagem de verificações 0, 
leituras lógicas 18, 
leituras físicas 1, 
leituras de servidor de páginas 0, 
leituras antecipadas 0, 
leituras antecipadas de servidor de páginas 0, 
leituras lógicas de LOB 0, 
leituras físicas de LOB 0, 
leituras de servidor de páginas LOB 0, 
leituras antecipadas de LOB 0, 
leituras antecipadas do servidor de páginas LOB 0.

Tabela 'Cliente'. 
Contagem de verificações 0, 
leituras lógicas 18, 
leituras físicas 1, 
leituras de servidor de páginas 0, 
leituras antecipadas 0, 
leituras antecipadas de servidor de páginas 0, 
leituras lógicas de LOB 0, 
leituras físicas de LOB 0, 
leituras de servidor de páginas LOB 0, 
leituras antecipadas de LOB 0, 
leituras antecipadas do servidor de páginas LOB 0.

Tabela 'Conta'. 
Contagem de verificações 0, 
leituras lógicas 24, 
leituras físicas 1, 
leituras de servidor de páginas 0, 
leituras antecipadas 0, 
leituras antecipadas de servidor de páginas 0, 
leituras lógicas de LOB 0, 
leituras físicas de LOB 0, 
leituras de servidor de páginas LOB 0, 
leituras antecipadas de LOB 0, 
leituras antecipadas do servidor de páginas LOB 0.

Tabela 'ClienteConta'. 
Contagem de verificações 1, 
leituras lógicas 2, 
leituras físicas 1, 
leituras de servidor de páginas 0, 
leituras antecipadas 0, 
leituras antecipadas de servidor de páginas 0, 
leituras lógicas de LOB 0, 
leituras físicas de LOB 0, 
leituras de servidor de páginas LOB 0, 
leituras antecipadas de LOB 0, 
leituras antecipadas do servidor de páginas LOB 0.
*/


SET STATISTICS IO ON
SET STATISTICS XML ON

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
ORDER BY Con.agencia, 
         Con.numero, 
		 Car.bandeira

SET STATISTICS IO OFF
SET STATISTICS XML OFF

-- STATISTICS IO
/*
Tabela 'Cliente'. 
Contagem de verificações 0, 
leituras lógicas 22, 
leituras físicas 1, 

Tabela 'ClientePF'. 
Contagem de verificações 0, 
leituras lógicas 28, 
leituras físicas 1, 

Tabela 'ClienteConta'. 
Contagem de verificações 1, 
leituras lógicas 19, 
leituras físicas 1, 

Tabela 'Worktable'. 
Contagem de verificações 0, 
leituras lógicas 0, 
leituras físicas 0, 

Tabela 'Conta'. 
Contagem de verificações 0, 
leituras lógicas 20, 
leituras físicas 1, 

Tabela 'Cartao'. 
Contagem de verificações 1, 
leituras lógicas 2, 
leituras físicas 1, 
*/


-- Ativar a apresentação do Plano de Execução
SET STATISTICS IO ON
SET STATISTICS XML ON

SELECT *
FROM CampeonatoBrasileiro
WHERE ID = 4000

SET STATISTICS IO OFF
SET STATISTICS XML OFF

-- STATISTICS IO
/*
Tabela 'CampeonatoBrasileiro'. 
Contagem de verificações 1, 
leituras lógicas 106
*/

EXEC sp_help 'dbo.CampeonatoBrasileiro'

ALTER TABLE CampeonatoBrasileiro
ADD PRIMARY KEY (ID)


SET STATISTICS IO ON
SET STATISTICS XML ON

SELECT *
FROM CampeonatoBrasileiro
WHERE ID = 4000

SET STATISTICS IO OFF
SET STATISTICS XML OFF

-- STATISTICS IO
/*
Tabela 'CampeonatoBrasileiro'. 
Contagem de verificações 0, 
leituras lógicas 2, 
leituras físicas 2, 
*/


------------------------------------------------------------------------------------------------
--> Índices
-- https://learn.microsoft.com/pt-br/sql/relational-databases/indexes/indexes
-- https://learn.microsoft.com/pt-br/sql/t-sql/statements/create-index-transact-sql
/*
- Hash 
- Não clusterizado com otimização de memória
- Clusterizado
- Não Clusterizado
- Exclusivo
- ColumnStore
- Indices com colunas incluídas
- Indices com colunas computadas
- Filtered
- Espacial
- XML
- Texto completo

Mais comuns: 
- Clusterizado
- Não Clusterizado
-- https://learn.microsoft.com/pt-br/sql/relational-databases/indexes/clustered-and-nonclustered-indexes-described
*/

EXEC sp_help 'dbo.CampeonatoBrasileiro'

-- Indice Não Clusterizado
SET STATISTICS IO ON
SET STATISTICS XML ON

SELECT *
FROM CampeonatoBrasileiro
WHERE mandante = 'Corinthians'

SET STATISTICS IO OFF
SET STATISTICS XML OFF

/*
Tabela 'CampeonatoBrasileiro'. 
Contagem de verificações 1, 
leituras lógicas 108, 
leituras físicas 1, 
leituras antecipadas 106,
*/


CREATE INDEX idxMandante ON CampeonatoBrasileiro(mandante) 

SET STATISTICS IO ON
SET STATISTICS XML ON

SELECT *
FROM CampeonatoBrasileiro
WHERE mandante = 'Corinthians'

SET STATISTICS IO OFF
SET STATISTICS XML OFF

/*
Tabela 'CampeonatoBrasileiro'. 
Contagem de verificações 1, 
leituras lógicas 108, 
leituras físicas 0, 
leituras antecipadas 0, 
*/
GO

-- Visualizar índices, chave primária e chaves estrangeiras
sp_helpindex 'CampeonatoBrasileiro'
GO
sp_pkeys 'CampeonatoBrasileiro'
GO
sp_fkeys 'CampeonatoBrasileiro'
GO


--> Observações
-- Chave primária: tem as caracteristicas de um índice clusterizado mais as funções de restrições
-- Um índice (mesmo clusterizado) não subtitui uma chave primária
-- Não é possível ter mais de um idice clusterizado na mesma tabela
/*
Índices vs Performance
- Se não existir, haverá problemas de performance.
- Se criado de forma inadequada, haverá problemas de performance. 
- Se criar muitos indices, haverá problemas de performance.
*/


-----------------------------------------------------------------------------------------------------------
-- Controle de permissões (Mecanismos do Banco de Dados)
/*
Protegíveis
Protegíveis são os recursos cujo acesso é regulado pelo sistema de autorização do Mecanismo de Banco de Dados do SQL Server.
https://docs.microsoft.com/pt-br/sql/relational-databases/security/securables

Permissões
Todo protegível do SQL Server tem permissões associadas que podem ser concedidas a uma entidade de segurança.
https://docs.microsoft.com/pt-br/sql/relational-databases/security/permissions-database-engine

GRANT 
Concede permissões em um protegível a uma entidade.
https://docs.microsoft.com/pt-br/sql/t-sql/statements/grant-transact-sql

DENY
Nega uma permissão a uma entidade de segurança.
https://docs.microsoft.com/pt-br/sql/t-sql/statements/deny-transact-sql

REVOKE
Remove uma permissão concedida ou negada anteriormente.
https://docs.microsoft.com/pt-br/sql/t-sql/statements/revoke-transact-sql


Exemplos de níveis de acesso/permissão
1. Acesso total.
2. Acesso parcial.
3. Acesso restrito.
*/


-- Criação de LOGIN no banco (MASTER)
USE master
GO
-- DROP LOGIN Jao
CREATE LOGIN Jao
	WITH PASSWORD = '123',
	DEFAULT_DATABASE = FastBank
GO


--Criação do usuário no banco FastBank
USE FastBank
GO
-- DROP USER Jao
CREATE USER Jao
	FOR LOGIN Jao
	WITH DEFAULT_SCHEMA = DBO
GO


-- Testes
/*
Abrir uma Nova Consulta
	Clicar com o botão direito
		Conexão
			Alterar conexão
				Logar com o novo usuario (Jao)
*/

USE FastBank

SELECT SUSER_NAME()
-- Consulta
SELECT * FROM Cliente
-- Function
SELECT dbo.fnCreditoConta(1)
-- View
SELECT * FROM vwClientesCartoes
-- Stored Procedure
EXEC stpMovimentacaoConta @Conta = 1
EXEC stpParcelasQuitacaoEmprestimo @CodEmprestimo = 1
-- Inserção
INSERT INTO LogErros
VALUES(1, GETDATE(), 'Teste de permissão!')
--Visualização
EXEC sp_helptext 'stpMovimentacaoContaJSON'



-- 1. Acesso total

-- Adiciona o membro Jao como proprietário do banco logado
ALTER ROLE DB_OWNER
ADD MEMBER Jao
GO

-- Retira o membro Jao como proprietário do banco logado
ALTER ROLE DB_OWNER
DROP MEMBER Jao
GO


-- 2. Acesso parcial

-- Concede permissão de execução para todos os objetos "executáveis" (EXEC) do schema 
GRANT EXECUTE
ON SCHEMA::DBO
TO Jao
-- Nega permissão de execução para todos os objetos "executáveis" (EXEC) do schema 
DENY EXECUTE
ON SCHEMA::DBO
TO Jao


-- Concede permissão de consulta para todos os objetos do schema 
GRANT SELECT
ON SCHEMA::DBO
TO Jao
-- Nega permissão de consulta para todos os objetos do schema 
DENY SELECT
ON SCHEMA::DBO
TO Jao


-- Adiciona permissão de leitura (SELECT) para todos os objetos
ALTER ROLE DB_DATAREADER
ADD MEMBER Jao
-- Retira permissão de leitura (SELECT) para todos os objetos
ALTER ROLE DB_DATAREADER
DROP MEMBER Jao


-- Adiciona permissão de escrita (INSERT, UPDATE e DELETE) para todos os objetos
ALTER ROLE DB_DATAWRITER
ADD MEMBER Jao
-- Retira permissão de escrita (INSERT, UPDATE e DELETE) para todos os objetos
ALTER ROLE DB_DATAWRITER
DROP MEMBER Jao



-- 3. Acesso restrito

-- Concede permissão especificamente de consulta para a vwClientesCartoes
GRANT SELECT 
ON OBJECT::DBO.vwClientesCartoes  
TO Jao
-- Nega permissão especificamente de consulta para a vwClientesCartoes
DENY SELECT 
ON OBJECT::DBO.vwClientesCartoes  
TO Jao


-- Concede permissão especificamente de execução para a stpMovimentacaoConta
GRANT EXECUTE 
ON OBJECT::DBO.stpMovimentacaoConta  
TO Jao  
-- Nega permissão especificamente de execução para a stpMovimentacaoConta
DENY EXECUTE
ON OBJECT::DBO.stpMovimentacaoConta  
TO Jao  


-- Concede permissão especificamente de visualização do código para a stpMovimentacaoContaJSON
GRANT VIEW DEFINITION
ON OBJECT::DBO.stpMovimentacaoContaJSON
TO Jao
-- Nega permissão especificamente de visualização do código para a stpMovimentacaoContaJSON
DENY VIEW DEFINITION
ON OBJECT::DBO.stpMovimentacaoContaJSON
TO Jao



---------------------------------------------------------------------------------------------------
-- Distribuição e otimização de espaço na criação dos arquivos de um banco

-- FILEGROUP

CREATE DATABASE DBTesteA                          -- Instrução para criação do Banco
ON PRIMARY                                        -- FileGroup (FG PRIMARY)
( NAME = 'Primario',                              -- Nome lógico do arquivo
  FILENAME = 'D:\MeuBanco\DBTesteA_Primario.mdf', -- Nome físico do arquivo
  SIZE = 256MB                                    -- Tamanho inicial do arquivo
)
LOG ON
( NAME = 'Log',
  FILENAME = 'F:\MeuBanco\DBTesteA_Log.ldf',
  SIZE = 256MB
)
GO


-- Distribuindo a carga de dados mais arquivos

CREATE DATABASE DBTesteA                          
ON PRIMARY                                        
( NAME = 'Primario',                              
  FILENAME = 'D:\MeuBanco\DBTesteA_Primario.mdf', 
  SIZE = 256MB                                    
),
( NAME = 'Secundario',                              
  FILENAME = 'E:\MeuBanco\DBTesteA_Secundario.ndf', 
  SIZE = 256MB                                    
)
LOG ON
( NAME = 'Log',
  FILENAME = 'F:\MeuBanco\DBTesteA_Log.ldf',
  SIZE = 256MB
)
GO



-- Distribuindo a carga de dados mais arquivos (outro exemplo)

CREATE DATABASE DBTesteA                          
ON PRIMARY                                        -- FG Primario
( NAME = 'Primario',                              
  FILENAME = 'D:\MeuBanco\DBTesteA_Primario.mdf', 
  SIZE = 256MB                                    
),
FILEGROUP DADOS                                   -- FG Dados
( NAME = 'Transacional_01',                              
  FILENAME = 'E:\MeuBanco\DBTesteA_T01.ndf', 
  SIZE = 1024MB                                    
),
( NAME = 'Transacional_02',                              
  FILENAME = 'E:\MeuBanco\DBTesteA_T02.ndf', 
  SIZE = 1024MB                                    
)
LOG ON
( NAME = 'Log',
  FILENAME = 'F:\MeuBanco\DBTesteA_Log.ldf',
  SIZE = 512MB
)
GO



-- Distribuindo a carga de dados mais arquivos (mais um exemplo)

CREATE DATABASE DBTesteA                          
ON PRIMARY                                        -- FG Primario
( NAME = 'Primario',                              
  FILENAME = 'D:\MeuBanco\DBTesteA_Primario.mdf', 
  SIZE = 256MB,                                    
  MAXSIZE = 10TB
),

FILEGROUP DADOS                                   -- FG Dados
( NAME = 'Transacional_01',                              
  FILENAME = 'E:\MeuBanco\DBTesteA_T01.ndf', 
  SIZE = 1024MB,    
  MAXSIZE = 10TB
),
( NAME = 'Transacional_02',                              
  FILENAME = 'E:\MeuBanco\DBTesteA_T02.ndf', 
  SIZE = 1024MB,
  MAXSIZE = 10TB
),

FILEGROUP HISTORICO                               -- FG Historico
( NAME = 'DadosHistoricos_01',                              
  FILENAME = 'G:\MeuBanco\DBTesteA_H01.ndf', 
  SIZE = 1024MB                                    
),
( NAME = 'DadosHistoricos_02',                              
  FILENAME = 'G:\MeuBanco\DBTesteA_H02.ndf', 
  SIZE = 1024MB                                    
)

LOG ON
( NAME = 'Log',
  FILENAME = 'F:\MeuBanco\DBTesteA_Log.ldf',
  SIZE = 512MB,
  MAXSIZE = 10TB
)
GO


-----------------------------------------------------------------------------------------------------
-- Backup e Restore
-- https://learn.microsoft.com/pt-br/sql/relational-databases/backup-restore/back-up-and-restore-of-sql-server-databases
-- https://learn.microsoft.com/pt-br/sql/relational-databases/backup-restore/full-database-backups-sql-server
-- https://learn.microsoft.com/pt-br/sql/relational-databases/backup-restore/differential-backups-sql-server
-- https://learn.microsoft.com/pt-br/sql/relational-databases/backup-restore/transaction-log-backups-sql-server


-- Restauração via SSMS

--- AdventureWorks
-- https://github.com/Microsoft/sql-server-samples/releases/tag/adventureworks
/*
Restauração de backup
	Botão direito em "Banco de Dados"
		Restaurar Banco de Dados
			Origem: Dispositivo (botão com ...)
				Adicionar (localizar o arquivo .bak e seleciona-lo)
				Clicar em Ok (confirmar o arquivo, a restauração e a finalização)
*/


-- Backup local simples
USE master

BACKUP DATABASE FastBank
TO DISK = 'D:\senai\Soluções\BKP_FastBank\fastbank.bak'
WITH STATS = 10, INIT
GO

RESTORE DATABASE FastBank
FROM DISK = 'D:\senai\Soluções\BKP_FastBank\fastbank.bak'
WITH STATS = 10
GO


-- Stored Procedures para o Backup e para o Restore

CREATE OR ALTER PROCEDURE stpBackupFastBak
AS
BEGIN
	DECLARE @Arquivo VARCHAR(100)

	SET @Arquivo = 'D:\senai\Soluções\BKP_FastBank\fastbank-' + FORMAT(GETDATE(), 'dd-MM-yyyy-hh-mm-ss') + '.bak'

	BACKUP DATABASE FastBank
	TO DISK = @Arquivo
	WITH STATS = 10, INIT
END
GO



CREATE OR ALTER PROCEDURE stpRestoreFastBak
	@Arquivo VARCHAR(100)
AS
BEGIN

	RESTORE DATABASE FastBankCopia
	FROM DISK = @Arquivo
	WITH STATS = 10
END
GO

-- Testes
USE master
GO

EXEC stpBackupFastBak
GO

BEGIN
	DECLARE @ArquivoBackup VARCHAR(100) = 'D:\senai\Soluções\BKP_FastBank\fastbank-19-06-2023-07-43-09.bak'
	EXEC stpRestoreFastBak @Arquivo = @ArquivoBackup
END
GO