/*------------------------------------------------------
Banco: FastBank
Autor: Ralfe
�ltima altera��o: 07/06/2023 - 22:45
Descri��o: Cria��o de Objetos de Banco de Dados
-------------------------------------------------------*/
/* Documenta��o:
	
	Transaction
	https://learn.microsoft.com/pt-br/sql/t-sql/language-elements/transactions-transact-sql

	TRY..CATCH
	https://learn.microsoft.com/pt-br/sql/t-sql/language-elements/try-catch-transact-sql

	RAISERROR
	https://learn.microsoft.com/en-us/sql/t-sql/language-elements/raiserror-transact-sql

	Tratamento de erros
	https://learn.microsoft.com/pt-br/sql/relational-databases/errors-events/errors-and-events-reference-database-engine

	Log de erros
	https://learn.microsoft.com/pt-br/sql/relational-databases/performance/view-the-sql-server-error-log-sql-server-management-studio
	https://learn.microsoft.com/pt-br/sql/relational-databases/system-stored-procedures/sp-readerrorlog-transact-sql

*/

USE FastBank
GO

---------------------------------------------------------------------------------
-- Transa��es
/*
Sequencia de instru��es que comp�em um unidade l�gica
-> TODAS as instru��es devem ser conclu�das para considerar que se obteve sucesso.
-> Obtendo sucesso  os dados (inseridos e/ou alterados e/ou exclu�dos) ser�o persistidos (gravados permanentemente) no BD.
-> Se uma das instru��es falhar, toda unidade l�gica (bloco de instru��es) ser� desconsiderada (e todas as opera��es descartadas).
-> Em caso de falha, os dados envolvidos ser�o mantidos da mesma forma que estavam antes do come�o da execu��o da unidade l�gica.


Propriedades de uma transa��o (ACID)
-> Atomicidade  - A transa��o � indivis�vel.
-> Consist�ncia - A transa��o deve manter a consist�ncia dos dados (respeitar as restri��es).
-> Isolamento   - O que ocorre em uma transa��o n�o interfere em outra transa��o (gerenciamento de concorr�ncia).
-> Durabilidade - Uma vez a transa��o confirmada os dados est�o persistidos.


inicio
	instru��o 01 (inser��o em conta) *
	instru��o 02 (inser��o em cart�o) * 
	instru��o 03 (inser��o em investimento) X
fim


BEGIN TRANSACTION
-> Inicio da unidade l�gicoa
-> A partir dele as modifica��es dos dados s�o controlados pela transa��o.

COMMIT
-> Confirma a conclus�o da unidade l�gica com sucesso.
-> Os dados modificados s�o persdistidos no BD

ROLLBACK
-> Cancela tudo que foi modificado na unidade l�gica voltando 
   os dados como estavam antes de iniciar a transa��o.
*/


-------------------------------------------------------------------------------------------------
-- TRY..CATCH

BEGIN TRY -- "Tenta" executar o bloco de instru��es

	BEGIN TRANSACTION

	-- instru��o 01 *
	-- instru��o 02 *
	-- instru��o 03 X
	
	COMMIT -- Se tudo correr bem, confirma as altera��es
END TRY

BEGIN CATCH -- Se ocorrer um erro "executa" as instru��es no bloco CATCH

	ROLLBACK -- Ignora/Desfaz as altera��es
END CATCH
GO

--------------------------------------------------------------------------------------------
-- RAISERROR

-- Como um PRINT
RAISERROR('Mensagem', 10, 1)
GO

RAISERROR('Opera��o executada com sucesso!', 10, 1)
GO

BEGIN
	DECLARE @Nome VARCHAR(30) = 'Jos� da Silva'

	PRINT 'Ol�, ' + @Nome + '!'

	RAISERROR('Ol�, %s!', 10, 1, @Nome)
END
GO



-- Stored Procedure de inser��o de novo emprestimo 
-- -> com gerenciamento de transa��es
-- -> Com TRY..CATCH

CREATE OR ALTER PROCEDURE stpNovoEmprestimo
	@Emprestimo tpEmprestimo READONLY
AS
BEGIN

	BEGIN TRY

		BEGIN TRANSACTION
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
					@ValorPago SMALLMONEY = NULL,

					@Erro INT

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
			-- SET @CodigoEmprestimo = @@IDENTITY

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

		-- Confirma a transa��o (persiste as altera��es dos dados permanentemente)
		COMMIT
	END TRY

	BEGIN CATCH
		-- Recuperando o c�digo do erro
		SET @Erro = @@ERROR
		-- Apresentando em Mensagem
		RAISERROR('Erro: %d', 10, 1, @Erro)

		-- Ignorar e desfazer as altera��es realizadas
		ROLLBACK
	END CATCH
END
GO



-- Acrescentar o gerenciamento de transa��es (TRANSACTION, TRY..CATCH)

-- Cria��o de uma nova conta de investimentos para clientes PJ, com um cart�o MasterCard e um investimento
-- de R$ 10.000,00 em a��es a curto prazo com taxa administrativa zero (stpContaInvestimentoPJ)


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

					@Erro INT

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

		COMMIT

	END TRY

	BEGIN CATCH
		SET @Erro = @@ERROR
		RAISERROR('Erro: %d', 10, 1, @Erro)
		ROLLBACK
	END CATCH
END
GO

--------------------------------------------------------------------------------
-- Tratamento de erros
/*
Existem duas origens para erros no SQL Server.
-> Gerados pelo engine do SQL Server (por um erro de execu��o)
-> Gerados pelos scripts (na programa��o) (erros relacionados as regras de neg�cio)

Os objetos de erro cont�m as informa��es:
-> N�mero do erro (Mensagem)
-> Mensagem de erro
-> Estado
-> Linha
-> Severidade (N�vel)
	Entre 0 e 9, s�o avisos ou alertas.
	10 � uma mensagem informativa gerada pelo programador.
	Acima 10 s�o detectaveis pelo TRY..CACTH.
	Entre 11 e 16 s�o erros que podem/devem ser corrigidos pelo desenvolvedor.
	Entre 17 e 19 s�o erros que somente o administrador dos banco pode corrigir.
	Entre 20 e 25 s�o erro cr�ticos/fatais que encerram a conex�o do cliente. Esses erros n�o podem ser tratados.
*/

USE FastBank
GO

SELECT *
FRON Cliente 
-- Mensagem 102, N�vel 15, Estado 1, Linha 1276
-- Sintaxe incorreta pr�xima a 'FRON'. 


SELECT *
FROM Clientes 
-- Mensagem 208, N�vel 16, Estado 1, Linha 1290
-- Nome de objeto 'Clientes' inv�lido.


DECLARE @Quantidade INT
SET @Quantidade = 12345678901234567890
-- Mensagem 8115, N�vel 16, Estado 2, Linha 1297
-- Erro de estouro aritm�tico ao converter expression no tipo de dados int.
GO


-- Implementa��o de tratamento de erros "personalizados" para determinados erros previstos e imprevistos

CREATE OR ALTER PROCEDURE stpNovoEmprestimo
	@Emprestimo tpEmprestimo READONLY
AS
BEGIN

	BEGIN TRY

		BEGIN TRANSACTION
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
					@ValorPago SMALLMONEY = NULL,

					@Erro INT,
					@Mensagem VARCHAR(100),
					@Severidade INT,
					@Estado INT,
					@Linha INT,
					@MensagemErro VARCHAR(MAX),
					@ErroCompleto VARCHAR(MAX) 

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
	
			-- Se o n�mero de parcelas for negativo
			IF @NumeroParcela < 0
				BEGIN
					-- Gera um objeto de erro (N�vel: 11, Estado: 1)
					RAISERROR('N�mero de parcelas inv�lido!',11, 1)
				END

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

		-- Confirma a transa��o (persiste as altera��es dos dados permanentemente)
		COMMIT
	END TRY

	BEGIN CATCH
		-- Recuperando o c�digo do erro
		SET @Erro = @@ERROR
		-- Tratamento espec�fico para o erro 515 (gerado pelo SQL Server)
		IF @Erro = 515
			BEGIN
				SET @MensagemErro = FORMATMESSAGE('Erro: %d, Mensagem padr�o: %s, Severidade: %d, Mensagem especifica: %s',
				                                  @Erro, ERROR_MESSAGE(), ERROR_SEVERITY(), 'C�digo do emprestimo inv�lido!')
			END
		-- Tratamento espec�fico para o erro 8115 (gerado pelo SQL Server)
		ELSE IF @Erro = 8115
			BEGIN
				SET @MensagemErro = FORMATMESSAGE('Erro: %d, Mensagem padr�o: %s, Severidade: %d, Mensagem especifica: %s',
				                                  @Erro, ERROR_MESSAGE(), ERROR_SEVERITY(), 'N�mero de parcelas inv�lido!')
			END
		-- Tratamento espec�fico para o erro 50000 (gerado pelo RAISERROR)
		ELSE IF @Erro = 50000
			BEGIN
				SET @MensagemErro = FORMATMESSAGE('Erro: %d, Mensagem padr�o: %s, Severidade: %d',
				                                  @Erro, ERROR_MESSAGE(), ERROR_SEVERITY())
			END
		ELSE
			-- Identifica��o de erros imprevistos
			BEGIN
				SET @MensagemErro = FORMATMESSAGE('Erro: %d, Mensagem padr�o: %s, Severidade: %d, Estado: %d, Linha: %d, Mensagem especifica: %s',
				                                  ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_LINE(),
												  'Erro imprevisto!')
			END

		-- Gera��o da Mensagem de Erro Completa que consiste na jun��o da 
		-- mensagem de erro (detalhes do erro) com os dados da conex�o e sess�o (retorno da fun��o fnConexaoSessao)
		SET @ErroCompleto = CONCAT(@MensagemErro,' - ', dbo.fnConexaoSessao(@@SPID))

		RAISERROR('%s', 10, 1, @ErroCompleto)

		-- Ignorar e desfazer as altera��es realizadas
		ROLLBACK
	END CATCH
END
GO


-- Mais informa��es sobre a conex�o e a sess�o
SELECT * FROM sys.dm_exec_connections
SELECT * FROM sys.dm_exec_sessions

SELECT DB_NAME() AS Banco,
	   Sessao.session_id AS Sessao,
       Sessao.login_name AS Login,
	   Sessao.host_name AS Computador,
	   Sessao.program_name AS Aplicacao,
	   Conexao.connect_time AS 'Inicio da conex�o',
	   Conexao.client_net_address AS IP
FROM sys.dm_exec_connections AS Conexao
INNER JOIN sys.dm_exec_sessions AS Sessao ON Conexao.session_id = Sessao.session_id
WHERE Conexao.session_id = @@SPID
GO


-- Fun��o que obt�m maiores imforma��es sobre a conex�o e sess�o correntes
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

	RETURN FORMATMESSAGE('Banco: %s, Sess�o: %s, Login: %s, M�quina: %s, @Software: %s, In�cio: %s. IP: %s',
	                      @Banco, @Sessao, @Login, @Maquina, @Software, @Inicio, @Ip)
END
GO

-- Chamada da fun��o para teste
SELECT dbo.fnConexaoSessao(@@SPID)
GO



--------------------------------------------------------------------------------
-- Logs de Erros
/*
	-> Tabela interna
	-> Registros de log do SQL Server
	-> Registros de log do Sistema Operacional (pouco usual)
*/


-- Tabela interna
CREATE TABLE LogErros(
	codigo INT IDENTITY,
	dataHora DATETIME DEFAULT GETDATE(),
	detalhamento VARCHAR(MAX),
	CONSTRAINT PK_LogErros PRIMARY KEY (codigo)
) 
GO


-- Implementa��o de tratamentos de erros 
-- e registro dos detalhes dos erros em tabela interna de log e no controle de logs do SQL Server

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

			-- (gerar um erro caso o aporte seja negativo)
			IF @Aporte < 0
				BEGIN
					-- Gera um objeto de erro (N�vel: 16, Estado: 2)
					RAISERROR('O valor do aporte n�o pode ser negativo!', 16, 2)
				END

			INSERT INTO Conta
			VALUES(@Agencia, @NumeroConta, @TipoConta, @Limite, @Ativa)

			-- (comente essa linha para gerar um erro)
			SET @CodigoConta = @@IDENTITY 

			INSERT INTO Cartao
			VALUES(@CodigoConta, @NumeroCartao, @Cvv, @Validade, @Bandeira, @Situacao)

			INSERT INTO Investimento
			VALUES(@CodigoConta, @TipoInvestimento, @Aporte, @TaxaAdminstrativa, @Prazo, @Risco, @Rentabilidade, @Finalizado)

		COMMIT

	END TRY

	BEGIN CATCH
		-- Recuperando o c�digo do erro
		SET @Erro = @@ERROR
		-- Tratamento espec�fico para o erro 515 (gerado pelo SQL Server)
		IF @Erro = 515
			BEGIN
				SET @MensagemErro = FORMATMESSAGE('Erro: %d, Mensagem padr�o: %s, Severidade: %d, Mensagem especifica: %s',
				                                  @Erro, ERROR_MESSAGE(), ERROR_SEVERITY(), 'C�digo da conta inv�lido!')
			END
		-- Tratamento espec�fico para o erro 50000 (gerado pelo RAISERROR)
		ELSE IF @Erro = 50000
			BEGIN
				SET @MensagemErro = FORMATMESSAGE('Erro: %d, Mensagem padr�o: %s, Severidade: %d',
				                                  @Erro, ERROR_MESSAGE(), ERROR_SEVERITY())
			END
		ELSE
			-- Identifica��o de erros imprevistos
			BEGIN
				SET @MensagemErro = FORMATMESSAGE('Erro: %d, Mensagem padr�o: %s, Severidade: %d, Estado: %d, Linha: %d, Mensagem especifica: %s',
				                                  ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_LINE(),
												  'Erro imprevisto!')
			END

		-- Gera��o da Mensagem de Erro Completa que consiste na jun��o da 
		-- mensagem de erro (detalhes do erro) com os dados da conex�o e sess�o (retorno da fun��o fnConexaoSessao)
		SET @ErroCompleto = CONCAT(@MensagemErro,' - ', dbo.fnConexaoSessao(@@SPID))

		-- Ignorar e desfazer as altera��es realizadas
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

-- Verificar logs de erros

-- Registros de log do FastBank
SELECT * FROM LogErros
GO

-- Registros de log do SQL Server
EXEC sp_readerrorlog
GO


------------------------------------------------------------------------------
-- SEQUENCE

DROP SEQUENCE Contador

CREATE SEQUENCE Contador -- Nome
AS INT                   -- Tipo
START WITH 0             -- In�cio  
INCREMENT BY 10          -- Incremento

-- Todos os objetos SEQUENCES do banco
SELECT *
FROM sys.sequences

-- Incremento
SELECT NEXT VALUE FOR Contador

-- Reiniciar
ALTER SEQUENCE Contador RESTART

-- Valor atual
SELECT current_value
FROM sys.sequences



-- Refatora��o da tabela LogErros

-- Cria��o de um objeto SEQUENCE para gera��o de c�digos
CREATE SEQUENCE CodigoLogErros
AS INT
START WITH 1
INCREMENT BY 1      


DROP TABLE IF EXISTS LogErros

CREATE TABLE LogErros(
	codigo INT DEFAULT NEXT VALUE FOR CodigoLogErros,
	dataHora DATETIME DEFAULT GETDATE(),
	detalhamento VARCHAR(MAX),
	CONSTRAINT PK_LogErros PRIMARY KEY (codigo)
) 
GO
