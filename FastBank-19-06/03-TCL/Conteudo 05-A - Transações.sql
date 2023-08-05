/*------------------------------------------------------
Banco: FastBank
Autor: Ralfe
Última alteração: 07/06/2023 - 22:45
Descrição: Criação de Objetos de Banco de Dados
-------------------------------------------------------*/
/* Documentação:
	
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
-- Transações
/*
Sequencia de instruções que compõem um unidade lógica
-> TODAS as instruções devem ser concluídas para considerar que se obteve sucesso.
-> Obtendo sucesso  os dados (inseridos e/ou alterados e/ou excluídos) serão persistidos (gravados permanentemente) no BD.
-> Se uma das instruções falhar, toda unidade lógica (bloco de instruções) será desconsiderada (e todas as operações descartadas).
-> Em caso de falha, os dados envolvidos serão mantidos da mesma forma que estavam antes do começo da execução da unidade lógica.


Propriedades de uma transação (ACID)
-> Atomicidade  - A transação é indivisível.
-> Consistência - A transação deve manter a consistência dos dados (respeitar as restrições).
-> Isolamento   - O que ocorre em uma transação não interfere em outra transação (gerenciamento de concorrência).
-> Durabilidade - Uma vez a transação confirmada os dados estão persistidos.


inicio
	instrução 01 (inserção em conta) *
	instrução 02 (inserção em cartão) * 
	instrução 03 (inserção em investimento) X
fim


BEGIN TRANSACTION
-> Inicio da unidade lógicoa
-> A partir dele as modificações dos dados são controlados pela transação.

COMMIT
-> Confirma a conclusão da unidade lógica com sucesso.
-> Os dados modificados são persdistidos no BD

ROLLBACK
-> Cancela tudo que foi modificado na unidade lógica voltando 
   os dados como estavam antes de iniciar a transação.
*/


-------------------------------------------------------------------------------------------------
-- TRY..CATCH

BEGIN TRY -- "Tenta" executar o bloco de instruções

	BEGIN TRANSACTION

	-- instrução 01 *
	-- instrução 02 *
	-- instrução 03 X
	
	COMMIT -- Se tudo correr bem, confirma as alterações
END TRY

BEGIN CATCH -- Se ocorrer um erro "executa" as instruções no bloco CATCH

	ROLLBACK -- Ignora/Desfaz as alterações
END CATCH
GO

--------------------------------------------------------------------------------------------
-- RAISERROR

-- Como um PRINT
RAISERROR('Mensagem', 10, 1)
GO

RAISERROR('Operação executada com sucesso!', 10, 1)
GO

BEGIN
	DECLARE @Nome VARCHAR(30) = 'José da Silva'

	PRINT 'Olá, ' + @Nome + '!'

	RAISERROR('Olá, %s!', 10, 1, @Nome)
END
GO



-- Stored Procedure de inserção de novo emprestimo 
-- -> com gerenciamento de transações
-- -> Com TRY..CATCH

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



-- Acrescentar o gerenciamento de transações (TRANSACTION, TRY..CATCH)

-- Criação de uma nova conta de investimentos para clientes PJ, com um cartão MasterCard e um investimento
-- de R$ 10.000,00 em ações a curto prazo com taxa administrativa zero (stpContaInvestimentoPJ)


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

			-- Armazena os valores recebidos pelo parâmetro @Conta em variáveis
			SELECT @Agencia = Agencia, 			
					@NumeroConta = NumeroConta,
					@TipoConta = Tipo,
					@Limite = Limite,
					@Ativa = Ativa
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
-> Gerados pelo engine do SQL Server (por um erro de execução)
-> Gerados pelos scripts (na programação) (erros relacionados as regras de negócio)

Os objetos de erro contém as informações:
-> Número do erro (Mensagem)
-> Mensagem de erro
-> Estado
-> Linha
-> Severidade (Nível)
	Entre 0 e 9, são avisos ou alertas.
	10 é uma mensagem informativa gerada pelo programador.
	Acima 10 são detectaveis pelo TRY..CACTH.
	Entre 11 e 16 são erros que podem/devem ser corrigidos pelo desenvolvedor.
	Entre 17 e 19 são erros que somente o administrador dos banco pode corrigir.
	Entre 20 e 25 são erro críticos/fatais que encerram a conexão do cliente. Esses erros não podem ser tratados.
*/

USE FastBank
GO

SELECT *
FRON Cliente 
-- Mensagem 102, Nível 15, Estado 1, Linha 1276
-- Sintaxe incorreta próxima a 'FRON'. 


SELECT *
FROM Clientes 
-- Mensagem 208, Nível 16, Estado 1, Linha 1290
-- Nome de objeto 'Clientes' inválido.


DECLARE @Quantidade INT
SET @Quantidade = 12345678901234567890
-- Mensagem 8115, Nível 16, Estado 2, Linha 1297
-- Erro de estouro aritmético ao converter expression no tipo de dados int.
GO


-- Implementação de tratamento de erros "personalizados" para determinados erros previstos e imprevistos

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

					@Erro INT,
					@Mensagem VARCHAR(100),
					@Severidade INT,
					@Estado INT,
					@Linha INT,
					@MensagemErro VARCHAR(MAX),
					@ErroCompleto VARCHAR(MAX) 

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
	
			-- Se o número de parcelas for negativo
			IF @NumeroParcela < 0
				BEGIN
					-- Gera um objeto de erro (Nível: 11, Estado: 1)
					RAISERROR('Número de parcelas inválido!',11, 1)
				END

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

		-- Confirma a transação (persiste as alterações dos dados permanentemente)
		COMMIT
	END TRY

	BEGIN CATCH
		-- Recuperando o código do erro
		SET @Erro = @@ERROR
		-- Tratamento específico para o erro 515 (gerado pelo SQL Server)
		IF @Erro = 515
			BEGIN
				SET @MensagemErro = FORMATMESSAGE('Erro: %d, Mensagem padrão: %s, Severidade: %d, Mensagem especifica: %s',
				                                  @Erro, ERROR_MESSAGE(), ERROR_SEVERITY(), 'Código do emprestimo inválido!')
			END
		-- Tratamento específico para o erro 8115 (gerado pelo SQL Server)
		ELSE IF @Erro = 8115
			BEGIN
				SET @MensagemErro = FORMATMESSAGE('Erro: %d, Mensagem padrão: %s, Severidade: %d, Mensagem especifica: %s',
				                                  @Erro, ERROR_MESSAGE(), ERROR_SEVERITY(), 'Número de parcelas inválido!')
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

		RAISERROR('%s', 10, 1, @ErroCompleto)

		-- Ignorar e desfazer as alterações realizadas
		ROLLBACK
	END CATCH
END
GO


-- Mais informações sobre a conexão e a sessão
SELECT * FROM sys.dm_exec_connections
SELECT * FROM sys.dm_exec_sessions

SELECT DB_NAME() AS Banco,
	   Sessao.session_id AS Sessao,
       Sessao.login_name AS Login,
	   Sessao.host_name AS Computador,
	   Sessao.program_name AS Aplicacao,
	   Conexao.connect_time AS 'Inicio da conexão',
	   Conexao.client_net_address AS IP
FROM sys.dm_exec_connections AS Conexao
INNER JOIN sys.dm_exec_sessions AS Sessao ON Conexao.session_id = Sessao.session_id
WHERE Conexao.session_id = @@SPID
GO


-- Função que obtém maiores imformações sobre a conexão e sessão correntes
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

-- Chamada da função para teste
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


-- Implementação de tratamentos de erros 
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

			-- Armazena os valores recebidos pelo parâmetro @Conta em variáveis
			SELECT @Agencia = Agencia, 			
					@NumeroConta = NumeroConta,
					@TipoConta = Tipo,
					@Limite = Limite,
					@Ativa = Ativa
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
START WITH 0             -- Início  
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



-- Refatoração da tabela LogErros

-- Criação de um objeto SEQUENCE para geração de códigos
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
