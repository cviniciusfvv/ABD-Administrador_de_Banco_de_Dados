/*-------------------------------------------
Banco: Livraria
Autor: Ralfe
�ltima altera��o: 10/05/2023 - 22:30 - Ralfe
Descri��o: 
	Exercicios de:
	-> View
	-> Function
	-> Type
	-> Stored Procedure
--------------------------------------------*/

	USE Livraria
	GO

-- 01. Crie uma View que d� acesso aos produtos (Livros e HQs) 
--     com as seguintes informa��es (atributos): titulo, genero, editora, pre�o custo, pseudonimo do autor.
--     vwProdutos

	CREATE OR ALTER VIEW vwProdutos AS
	SELECT P.titulo,
	       P.genero,
		   P.editora,
		   P.precoCusto,
		   A.pseudonimo
	FROM Produto AS P
	INNER JOIN AutorProduto AS AP ON P.codigo = AP.codigoProduto
	INNER JOIN Autor AS A ON AP.codigoAutor = A.codigo
	GO

	SELECT * FROM vwProdutos
	GO

-- 02. Crie uma Function que receba um codigo de produto por par�metro e retorne o pre�o de venda
--     (pre�o de custo mais 10%)
--     fnProdutoPrecoVenda

	CREATE OR ALTER FUNCTION fnProdutoPrecoVenda(@Produto INT) RETURNS SMALLMONEY
	AS
	BEGIN
		DECLARE @PrecoVenda SMALLMONEY

		SELECT @PrecoVenda = P.precoCusto * 1.1
		FROM Produto AS P
		WHERE P.codigo = @Produto

		RETURN @PrecoVenda
	END
	GO

	-- Chamada da Function
	SELECT dbo.fnProdutoPrecoVenda(1)
	GO

	SELECT P.codigo,
	       P.titulo,
		   P.precoCusto AS 'Pre�o custo',
		   dbo.fnProdutoPrecoVenda(3) AS 'Pre�o venda'
	FROM Produto AS P
	WHERE P.codigo = 3
	GO


-- 03. Crie uma Function que receba o c�digo de um autor e retorne quantas obras (livros e HQs) ele possue cadastrado
--     fnQuantidadeObras


	CREATE OR ALTER FUNCTION fnQuantidadeObras(@Autor INT) RETURNS INT
	AS 
	BEGIN
		DECLARE @QuantidadeObras INT

		SELECT @QuantidadeObras = COUNT(*)
		FROM Autor AS A
		INNER JOIN AutorProduto AS AP ON A.codigo = AP.codigoAutor
		INNER JOIN Produto AS P ON AP.codigoProduto = P.codigo
		WHERE A.codigo = @Autor

		RETURN @QuantidadeObras
	END
	GO

	-- Chamada da Function

	DECLARE @CodigoAutor INT = 2

	SELECT Autor.pseudonimo,
	       dbo.fnQuantidadeObras(@CodigoAutor) AS 'Quantidade de obras cadastradas'
	FROM Autor
	WHERE Autor.codigo = @CodigoAutor
	GO

-- 04. Crie uma Stored Procedure que fa�a o reajuste do pre�o de custo em 5% somente nos Livros
--     stpReajusteLivros

	CREATE OR ALTER PROCEDURE stpReajusteLivros
	AS
	BEGIN
		-- Desabilita as mensagem autom�ticas na guia mensagem
		SET NOCOUNT ON

		UPDATE Produto
		SET precoCusto = precoCusto * 1.05
		WHERE codigo IN (SELECT P.codigo
						 FROM Produto AS P
						 INNER JOIN Livro AS L ON P.codigo = L.codigoProduto)

		-- Retorna a quantidade de linhas afetadas
		RETURN @@ROWCOUNT
	END
	GO


	BEGIN
		DECLARE @Retorno INT

		-- Antes da altera��o
		SELECT P.titulo,
			   P.precoCusto
		FROM Produto AS P
		INNER JOIN Livro AS L ON P.codigo = L.codigoProduto

		-- Execu��o
		EXEC @Retorno = stpReajusteLivros

		-- Apresenta��o do retorno em Mensagem
		PRINT @Retorno

		-- Depois da altera��o
		SELECT P.titulo,
			P.precoCusto
		FROM Produto AS P
		INNER JOIN Livro AS L ON P.codigo = L.codigoProduto
	END
	GO


-- 05. Crie uma Stored Procedure que insira uma Venda com tr�s Itens.
--     Todos os dados devem ser passados por par�metro para a SP
--     stpInsercaoVenda 


	CREATE TYPE tpVenda AS TABLE(
		CodigoCliente INT,
		Nf INT,
		Serie VARCHAR(5),
		Emissao DATE
	)


	CREATE TYPE tpVendaItens AS TABLE(
		sequencia INT,
		codigoProduto INT,
		quantidade INT,
		preco SMALLMONEY
	)
	GO



	CREATE OR ALTER PROCEDURE stpInsercaoVenda
		@Venda tpVenda READONLY,
		@Itens tpVendaItens READONLY
	AS
	BEGIN
		-- Declara��o de vari�veis
		DECLARE	@CodigoVenda INT,
				@CodigoCliente INT,
				@Nf INT,
				@Serie VARCHAR(5),
				@Emissao DATE,

				@Sequencia INT,
				@CodigoProduto INT,
				@Quantidade INT,
				@Preco SMALLMONEY,

				@QuantidadeItens INT,
				@Contador INT = 1

		-- Recupera os dados do par�metro @Venda
		SELECT @CodigoCliente = CodigoCliente,
			   @Nf = Nf,
			   @Serie = Serie,
			   @Emissao = Emissao
		FROM @Venda

		-- Obt�m a quantidade de itens
		SELECT @QuantidadeItens = COUNT(*) 
		FROM @Itens

		-- Inser��o da Venda
		INSERT INTO Venda
		VALUES(@CodigoCliente, @Nf, @Serie, @Emissao)

		-- Recupera��o do c�digo da venda
		SET @CodigoVenda = @@IDENTITY

		-- Inser��es de itens

		WHILE(@Contador <= @QuantidadeItens)
			BEGIN
				-- Pega os dados de cada item
				SELECT @CodigoProduto = codigoProduto,
					   @Quantidade = quantidade,
					   @Preco = preco * quantidade
				FROM @Itens
				WHERE sequencia = @Contador

				-- Inser��o na tabela permanente VendaItem
				INSERT INTO VendaItem
				VALUES(@CodigoVenda, @CodigoProduto, @Quantidade, @Preco)

				-- Incrementa o contador
				SET @Contador = @Contador + 1
			END
	END
	GO


	BEGIN
		DECLARE @ValoresVenda tpVenda,
				@ValoresItens tpVendaItens

		-- Insere dados da Venda
		INSERT INTO @ValoresVenda
		VALUES(2, (SELECT MAX(nf) FROM Venda) + 1, (SELECT MAX(serie) FROM Venda), GETDATE())

		-- Insere dados dos Itens da Venda
		INSERT INTO @ValoresItens
		VALUES(1, 7, 1, 40.00),
			  (2, 4, 2, 300.00),
			  (3, 2, 1, 50.00),
			  (4, 10, 1, 165.00),
			  (5, 11, 2, 110.00)

		-- Executa a SP
		EXEC stpInsercaoVenda @Venda = @ValoresVenda,
							  @Itens = @ValoresItens 

		-- Verifica do resultado
		SELECT *
		FROM Venda AS V
		INNER JOIN VendaItem AS Item ON V.codigo = Item.codigoVenda
		WHERE V.codigo = (SELECT MAX(codigo) FROM Venda)
	END
	GO


-- 06. Crie uma Stored Procedure que insira uma nova HQ que possui, al�m do autor, um desenhista e um colorista
--     (utilize um autor, um desenhista e um colorista j� cadastrado). Lembre tamb�m que cada produto possui duas imagens 
--     (uma capa e uma contracapa). Todos os dados devem ser passados por par�metro e o c�digo gerado para o novo produto
--     deve ser retornado por meio de um par�metro de sa�da.
--     stpInsercaoHq


	CREATE TYPE tpHq AS TABLE(
		Titulo VARCHAR(100),
		Genero VARCHAR(50),
		Editora VARCHAR(50),
		Ano INT,
		CapaDura BIT,
		Sinopse VARCHAR(MAX),
		PrecoCusto SMALLMONEY,
		Margem FLOAT,
		CodigoDesenhista INT,
		CodigoColorista INT,
		Volume INT,
		VolumeArco INT,
		CodigoAutor INT
	)
	GO



	CREATE OR ALTER PROCEDURE stpInsercaoHq
		@Hq tpHq READONLY
	AS
	BEGIN

		DECLARE @CodigoProduto INT,
				@Titulo VARCHAR(100),
				@Genero VARCHAR(50),
				@Editora VARCHAR(50),
				@Ano INT,
				@CapaDura BIT,
				@Sinopse VARCHAR(MAX),
				@PrecoCusto SMALLMONEY,
				@Margem FLOAT,
				@CodigoDesenhista INT,
				@CodigoColorista INT,
				@Volume INT,
				@VolumeArco INT,
				@CodigoAutor INT,
				@CaminhoCapa VARCHAR(100) = '',
				@DescricaoCapa VARCHAR(25) = 'capa',
				@CaminhoContraCapa VARCHAR(100) = '',
				@DescricaoContraCapa VARCHAR(25) = 'contracapa'


		SELECT 	@Titulo = Titulo,
				@Genero = Genero,
				@Editora = Editora,
				@Ano = Ano,
				@CapaDura = CapaDura,
				@Sinopse = Sinopse,
				@PrecoCusto = PrecoCusto,
				@Margem = Margem,
				@CodigoDesenhista = CodigoDesenhista,
				@CodigoColorista = CodigoColorista,
				@Volume = Volume,
				@VolumeArco = VolumeArco,
				@CodigoAutor = CodigoAutor
		FROM @Hq

		-- Inser��o em Produto
		INSERT INTO Produto
		VALUES(@Titulo, @Genero, @Editora, @Ano, @CapaDura, @Sinopse, @PrecoCusto, @Margem)

		-- Recuperar o c�digo gerado
		SET @CodigoProduto = @@IDENTITY

		-- Inser��o em HQ
		INSERT INTO HQ
		VALUES(@CodigoProduto, @CodigoDesenhista, @CodigoColorista, @Volume, @VolumeArco)

		-- Inser��o das imagens
		INSERT INTO Imagem
		VALUES(@CodigoProduto, CONCAT('\imagens\',@CodigoProduto,'a.jpg'), @DescricaoCapa),
			  (@CodigoProduto, CONCAT('\imagens\',@CodigoProduto,'b.jpg'), @DescricaoContraCapa)

		-- Inser��o no AutorProduto
		INSERT INTO AutorProduto
		VALUES(@CodigoAutor, @CodigoProduto)

	END
	GO



	BEGIN
		DECLARE @ValoresHq tpHq

		INSERT INTO @ValoresHq
		VALUES('Do Inferno', 
			   'Graphic Novels', 
			   'Veneta', 
			   2014, 
			   1, 
			   'Essa � a hist�ria de Jack Estripador, o mais misterioso e famoso assassino de todos os tempos. Escrita por Alan Moore,o criador de hist�rias em quadrinhos como Watchmen e V de Vingan�a, Do Inferno � uma reflex�o a respeito da mente enlouquecida cuja viol�ncia e selvageria deu in�cio ao s�culo 20.',
			   85.00,
			   0.1,
			   4,
			   6,
			   0,
			   1,
			   7)


		EXEC stpInsercaoHq @Hq = @ValoresHq

		-- Verifica��o do resultado
		SELECT *
		FROM Produto AS P
		INNER JOIN HQ AS HQ ON P.codigo = HQ.codigoProduto
		INNER JOIN Imagem AS I ON HQ.codigoProduto = I.codigoProduto
		INNER JOIN AutorProduto AS AP ON P.codigo = AP.codigoProduto
		INNER JOIN Autor AS A ON AP.codigoAutor = A.codigo
		INNER JOIN Desenhista AS D ON HQ.codigoDesenhista = D.codigo
		INNER JOIN Colorista AS C ON HQ.codigoColorista = C.codigo
		WHERE P.codigo = (SELECT MAX(codigo) FROM Produto)
	END 
	GO


