/*---------------------------------------------
Banco: FastBank
Autor: Ralfe
�ltima altera��o: 12/04/2023 - 22:45 - Ralfe
Descri��o: Testes de consultas de dados
--------------------------------------------*/
/* Documenta��o:

	SELECT
	https://learn.microsoft.com/pt-br/sql/t-sql/queries/select-transact-sql

	Resumo:
	SELECT (Sele��o) -> Atributos (colunas) que ser�o apresentados
	FROM (Origem) -> Tabela de refer�ncia para busca dos dados
	JOIN (Jun��es) -> Associa��es com outra(s) tabela(s) acrescentando dados para a consulta
	WHERE (Filtros) -> Registros (linhas) que ser�o apresentados
	ORDER BY (Ordena��es) e GROUP BY (Agrupamentos) -> Registros apresentados

	Cl�usulas/ Argumentos:
	AS - Apelidos (ALIAS) para colunas
	IIF() - Substitui��o de valores em colunas
	LIKE - Varredura em textos
	BETWEEN - Faixa de valores/per�odo
	TOP() - Primeiros registros
	DISTINCT - Registros sem repeti��o

	Fun��es de agrega��o (extra��o de informa��es �nicas ou agrupadas de colunas)
	https://learn.microsoft.com/pt-br/sql/t-sql/functions/aggregate-functions-transact-sql
	MIN()
	MAX()
	SUM()
	AVG()
	COUNT()

	Formata��es - FORMAT() 
	https://learn.microsoft.com/pt-br/sql/t-sql/functions/format-transact-sql

	Data e hora
	https://learn.microsoft.com/pt-br/sql/t-sql/functions/format-transact-sql

	Fun��es de cadeia de caracteres (textos)
	https://learn.microsoft.com/pt-br/sql/t-sql/functions/string-functions-transact-sql

	JOIN
	https://learn.microsoft.com/pt-br/sql/relational-databases/performance/joins
	Observa��o: Mais exemplos de varia��es de JOINS no banco Livraria.

	Subconsultas
	https://learn.microsoft.com/pt-br/sql/relational-databases/performance/subqueries
*/

-- Cria��o do Banco
CREATE DATABASE FastBank
GO

-- Conex�o com o Banco
USE Fastbank
GO

-- Consultas gerais
SELECT * FROM Cliente
SELECT * FROM ClientePF
SELECT * FROM ClientePJ
SELECT * FROM Endereco
SELECT * FROM Contato
SELECT * FROM ClienteConta
SELECT * FROM Conta
SELECT * FROM Cartao
SELECT * FROM Movimentacao
SELECT * FROM Emprestimo
SELECT * FROM EmprestimoParcela
SELECT * FROM Investimento


-- Todas as colunas e todas as linhas
SELECT *
FROM Endereco


-- Colunas selecionadas e todas as linhas
SELECT logradouro,
       cidade
FROM Endereco


-- Todas as colunas com filtros de registros
SELECT *
FROM Endereco
WHERE cidade = 'S�o Paulo'



-- Todas as colunas com filtros de registros
SELECT *
FROM Endereco
WHERE cidade <> 'S�o Paulo' AND logradouro LIKE 'Avenida%'


-- Alterar visualiza��o de dados de uma coluna por meio de l�gica
SELECT agencia,
       numero,
	   IIF(ativa = 0, 'Inativa', 'Ativa')
FROM Conta



-- Apelido (alias) para o titulo da coluna
SELECT agencia AS 'Ag�ncia',
       numero AS 'N�mero',
	   IIF(ativa = 0, 'Inativa', 'Ativa') AS 'Situa��o'
FROM Conta


-- Filtrando registros por per�odo
SELECT valorSolicitado AS [Valor solicitado],
       numeroParcela AS [N�mero de parcelas],
       dataSolicitacao AS [Data de solicita��o]
FROM Emprestimo
WHERE dataSolicitacao BETWEEN '01/12/2022' AND '31/12/2022'


-- Ordena��o
SELECT operacao,
	   dataHora,
       valor
FROM Movimentacao
ORDER BY operacao, valor



-- Filtro e Ordena��o
SELECT operacao AS 'Opera��o',
       valor AS 'Valor',
	   dataHora AS 'Data e Hora'
FROM Movimentacao
WHERE valor BETWEEN 1000 AND 3000
ORDER BY operacao, valor DESC



-- Define quantos registros ser�o exibidos (os primeiros de acordo com a ordena��o)
SELECT TOP(3) operacao,
              valor
FROM Movimentacao
ORDER BY valor DESC



-- Elimina repeti��es
SELECT DISTINCT bandeira,
                situacao
FROM Cartao


SELECT DISTINCT bandeira
FROM Cartao


-- Fun��es de agrega��o
SELECT MIN(valor) AS 'Menor movimenta��o',
	   MAX(valor) AS 'Maior movimenta��o',
	   SUM(valor) AS 'Soma total',
	   AVG(valor) AS 'M�dia aritm�tica',
	   COUNT(valor) AS 'Quantidade de movimenta��es'	
FROM Movimentacao


-- Agrupamentos (GROUP BY)
SELECT codigoCartao
FROM Movimentacao
GROUP BY codigoCartao
        

SELECT operacao
FROM Movimentacao
GROUP BY operacao


SELECT codigoCartao,
       operacao
FROM Movimentacao
GROUP BY codigoCartao, operacao


-- Agrupamento e Agrega��o
SELECT codigoCartao,
       operacao,
	   COUNT(*) AS 'Quantidade de movimenta��es'
FROM Movimentacao
GROUP BY codigoCartao, operacao


SELECT operacao,
       MIN(valor) AS 'Menor movimenta��o',
	   MAX(valor) AS 'Maior movimenta��o',
	   SUM(valor) AS 'Soma total',
	   AVG(valor) AS 'M�dia aritm�tica',
	   COUNT(valor) AS 'Quantidade de movimenta��es'	
FROM Movimentacao
GROUP BY operacao


SELECT codigoCartao,
       MIN(valor) AS 'Menor movimenta��o',
	   MAX(valor) AS 'Maior movimenta��o',
	   SUM(valor) AS 'Soma total',
	   AVG(valor) AS 'M�dia aritm�tica',
	   COUNT(valor) AS 'Quantidade de movimenta��es'	
FROM Movimentacao
GROUP BY codigoCartao


-- Formata��es

-- Data
SELECT FORMAT(dataSolicitacao, 'd', 'pt-br') AS 'Portugu�s Brasil',
       FORMAT(dataSolicitacao, 'd', 'en-US') AS 'US English',
       FORMAT(dataSolicitacao, 'd', 'en-gb') AS 'British English',
	   FORMAT(dataSolicitacao, 'd', 'de-de') AS 'German',
	   FORMAT(dataSolicitacao, 'd', 'zh-cn') AS 'Chinese Simplified'
FROM Emprestimo

SELECT FORMAT(dataSolicitacao, 'D', 'pt-br') AS 'Portugu�s Brasil',
	   FORMAT(dataSolicitacao, 'D', 'en-US') AS 'US English',
       FORMAT(dataSolicitacao, 'D', 'en-gb') AS 'British English',
	   FORMAT(dataSolicitacao, 'D', 'de-de') AS 'German',
	   FORMAT(dataSolicitacao, 'D', 'zh-cn') AS 'Chinese Simplified'
FROM Emprestimo


-- Moeda
SELECT FORMAT(valorSolicitado, 'C', 'pt-br') AS 'Portugu�s Brasil',
       FORMAT(valorSolicitado, 'C', 'en-US') AS 'US English',
	   FORMAT(valorSolicitado, 'C', 'en-gb') AS 'British English',
	   FORMAT(valorSolicitado, 'C', 'de-de') AS 'German',
	   FORMAT(valorSolicitado, 'C', 'zh-cn') AS 'Chinese'
FROM Emprestimo


-- Porcentagem
SELECT juros AS 'Como fra��o',
	   FORMAT(juros, 'P', 'pt-br') AS 'Como porcentagem'
FROM Emprestimo



-- Data e Hora

-- Retorna a data do servidor como um DATETIME
SELECT GETDATE()

-- Retorna a data do servidor como um DATETIME2
SELECT SYSDATETIME()

-- Retorna a data do servidor como UTC (Refer�ncia do Meridiano Greenwich)
SELECT SYSUTCDATETIME()

SELECT SYSDATETIMEOFFSET()


SELECT FORMAT(dataSolicitacao, 'd', 'pt-br') AS 'Data de solicita��o',
	   DAY(dataSolicitacao) AS Dia,	
	   MONTH(dataSolicitacao) AS M�s,
	   YEAR(dataSolicitacao) AS Ano
FROM Emprestimo



-- Calcular diferen�a entre data
SELECT DATEDIFF(DAY,'01/03/2023','27/03/2023')

SELECT DATEDIFF(MONTH,'01/03/2020','27/03/2023')

SELECT DATEDIFF(YEAR,'01/03/2020','27/03/2023')



-- Manipula��o de textos

-- Espa�os em branco s�o considerados
UPDATE Cliente
SET nome_razaoSocial = '   Jaime C�mara Val�rio'
WHERE codigo = 10


SELECT * 
FROM Cliente
WHERE nome_razaoSocial = 'Jaime C�mara Val�rio'


-- Retirar espa�os em branco ante e depois de um texto
SELECT * 
FROM Cliente
WHERE TRIM(nome_razaoSocial) = 'Jaime C�mara Val�rio'


-- Retorna a quantidade de caracteres de um texto
SELECT LEN(nome_razaoSocial)
FROM Cliente
WHERE codigo = 10


-- Combina��es de fun��es (come�a a execu��o de dentro pra fora)
SELECT LEN( TRIM(nome_razaoSocial) )
FROM Cliente
WHERE codigo = 10


-- Retorna um quantidade pr�-definida de caracteres a esquerda
SELECT LEFT(nome_razaoSocial, 10)
FROM Cliente
WHERE codigo = 10


-- Retorna um quantidade pr�-definida de caracteres a direita
SELECT RIGHT(nome_razaoSocial, 10)
FROM Cliente
WHERE codigo = 10


-- Pesquisa se um (ou mais) caracteres existem em um texto

UPDATE Cliente
SET nome_razaoSocial = 'Jaime de C�mara Val�rio'
WHERE codigo = 10


SELECT CHARINDEX('de', nome_razaoSocial)
FROM Cliente
WHERE codigo = 10


SELECT CHARINDEX(' ', nome_razaoSocial)
from Cliente


-- Retorna uma parte do texto
SELECT SUBSTRING(nome_razaoSocial, 10, 6)
FROM Cliente
WHERE codigo = 10


SELECT SUBSTRING(nome_razaoSocial, 1, CHARINDEX(' ', nome_razaoSocial))
FROM Cliente

-- Todas as letras minusculas
SELECT LOWER(nome_razaoSocial)
FROM Cliente


-- Todas as letras mai�sculas
SELECT UPPER(nome_razaoSocial)
FROM Cliente


-- Concatena��es
SELECT CONCAT(nome_razaoSocial,': ', TRIM(usuario), ' - ', senha)
FROM Cliente



-- Convers�es de tipos
SELECT 'Ag�ncia: ' +  agencia + ', Conta: ' + numero + ', Limite: ' + CAST(limite AS VARCHAR)
FROM Conta


SELECT 'Ag�ncia: ' +  agencia + 
       ' - Conta: ' + numero + 
	   ' - Limite: ' + CAST( FORMAT(limite, 'C', 'pt-br') AS VARCHAR) AS 'Dados do cliente'
FROM Conta



/*------------------------------------------------------------------------------------------
Consultas em v�rias tabelas (exemplos com WHERE para testes e compreens�o do relacionamento)
------------------------------------------------------------------------------------------*/

-- Relacionamento 1:1
-- Envolvendo duas tabelas
--------------------------

-- ClientePF (todos os atributos)
SELECT Cli.nome_razaoSocial AS 'Nome',
	   IIF(Cli.nomeSocial_fantasia IS NULL, 'N�o informado', Cli.nomeSocial_fantasia)AS 'Nome social',
	   Cli.foto_logo AS 'Foto',
	   FORMAT(Cli.dataNascimento_abertura, 'd', 'pt-br') AS 'Data de nascimento',
	   Cli.usuario,
	   Cli.senha,
	   Cli.codigo AS 'PK de Cliente',
	   PF.codigoCliente AS 'PK e FK de ClientePF',
	   PF.rg AS 'RG',
	   PF.cpf AS 'CPF'
FROM Cliente AS Cli, ClientePF AS PF
WHERE Cli.codigo = PF.codigoCliente


-- ClientePF (atributos selecionados)
SELECT Cli.nome_razaoSocial AS 'Nome',
	   IIF(Cli.nomeSocial_fantasia IS NULL, 'N�o informado', Cli.nomeSocial_fantasia)AS 'Nome social',
	   Cli.foto_logo AS 'Foto',
	   FORMAT(Cli.dataNascimento_abertura, 'd', 'pt-br') AS 'Data de nascimento',
	   PF.rg AS 'RG',
	   PF.cpf AS 'CPF'
FROM Cliente AS Cli, ClientePF AS PF
WHERE Cli.codigo = PF.codigoCliente



-- ClientePJ (todos os atributos)
SELECT Cli.nome_razaoSocial AS 'Razao social',
	   Cli.nomeSocial_fantasia AS 'Nome fantasia',
	   Cli.foto_logo AS 'Logo',
	   FORMAT(Cli.dataNascimento_abertura, 'd', 'pt-br') AS 'Data de abertura',
	   Cli.usuario,
	   Cli.senha,
	   Cli.codigo AS 'PK de Cliente',
	   PJ.codigoCliente AS 'PK e FK de ClientePJ',
	   PJ.cnpj AS 'CNPJ',
	   PJ.inscricaoMunicipal AS 'IM',
	   PJ.inscricaoEstadual AS 'IE'
FROM Cliente AS Cli, ClientePJ AS PJ
WHERE Cli.codigo = PJ.codigoCliente


-- ClientePJ (atributos selecionados)
SELECT Cli.nome_razaoSocial AS 'Razao social',
	   IIF(Cli.nomeSocial_fantasia IS NULL, 'N�o informado', Cli.nomeSocial_fantasia)AS 'Nome fantasia',
	   Cli.foto_logo AS 'Logo',
	   FORMAT(Cli.dataNascimento_abertura, 'd', 'pt-br') AS 'Data de abertura',
	   PJ.cnpj AS 'CNPJ',
	   PJ.inscricaoMunicipal AS 'IM',
	   IIF(PJ.inscricaoEstadual IS NULL, '', PJ.inscricaoEstadual) AS 'IE'
FROM Cliente AS Cli, ClientePJ AS PJ
WHERE Cli.codigo = PJ.codigoCliente



-- Relacionamento 1:n
-- Envolvendo tr�s tabelas
--------------------------

-- todos os atributos
SELECT Cli.nome_razaoSocial AS 'Nome',
	   IIF(Cli.nomeSocial_fantasia IS NULL, 'N�o informado', Cli.nomeSocial_fantasia)AS 'Nome social',
	   Cli.foto_logo AS 'Foto',
	   FORMAT(Cli.dataNascimento_abertura, 'd', 'pt-br') AS 'Data de nascimento',
	   Cli.usuario,
	   Cli.senha,
	   Cli.codigo AS 'PK de Cliente',
	   PF.codigoCliente AS 'PK e FK de ClientePF',
	   PF.rg AS 'RG',
	   PF.cpf AS 'CPF',
	   Cli.codigoEndereco AS 'FK em Cliente',
	   E.codigo AS 'PK de Endereco',
	   E.logradouro,
	   E.bairro,
	   E.cidade,
	   E.uf,
	   E.cep
FROM Cliente AS Cli, 
     ClientePF AS PF,
	 Endereco AS E
WHERE Cli.codigo = PF.codigoCliente
  AND Cli.codigoEndereco = E.codigo


-- Atributos selecionados
SELECT Cli.nome_razaoSocial AS 'Nome',
	   IIF(Cli.nomeSocial_fantasia IS NULL, 'N�o informado', Cli.nomeSocial_fantasia)AS 'Nome social',
	   Cli.foto_logo AS 'Foto',
	   FORMAT(Cli.dataNascimento_abertura, 'd', 'pt-br') AS 'Data de nascimento',
	   PF.rg AS 'RG',
	   PF.cpf AS 'CPF',
	   E.logradouro AS 'Rua',
	   E.bairro,
	   E.cidade,
	   E.uf
FROM Cliente AS Cli, 
     ClientePF AS PF,
	 Endereco AS E
WHERE Cli.codigo = PF.codigoCliente
  AND Cli.codigoEndereco = E.codigo
ORDER BY Cli.codigo


/*-------------------------------------------
Inser��o de registros em tabelas dependentes
--------------------------------------------*/

-- SELECT * FROM Endereco
-- SELECT * FROM Cliente
-- SELECT * FROM ClientePF

-- Primeiro a inser��o na tabela que ser� referenciada
INSERT INTO Cliente
VALUES (2, 'Fernanda Ribeiro Souza', 'Fernanda Ribeiro', '\foto\123.jpg','30/03/1989','fernanda', 654)

-- Obten��o do codigo gerado
SELECT MAX(codigo) FROM Cliente

-- Inser��o do complemento dos dado do ClientePF
INSERT INTO ClientePF
VALUES (11, '48996867900', '264125892')
GO


-- Envolvendo quatro tabelas
----------------------------

-- Todos os atributos
SELECT Cli.nome_razaoSocial AS 'Nome',
	   IIF(Cli.nomeSocial_fantasia IS NULL, 'N�o informado', Cli.nomeSocial_fantasia)AS 'Nome social',
	   Cli.foto_logo AS 'Foto',
	   FORMAT(Cli.dataNascimento_abertura, 'd', 'pt-br') AS 'Data de nascimento',
	   Cli.usuario,
	   Cli.senha,
	   Cli.codigo AS 'PK de Cliente',
	   PF.codigoCliente AS 'PK e FK de ClientePF',
	   PF.rg AS 'RG',
	   PF.cpf AS 'CPF',
	   Cli.codigoEndereco AS 'FK em Cliente',
	   E.codigo AS 'PK de Endereco',
	   E.logradouro,
	   E.bairro,
	   E.cidade,
	   E.uf,
	   E.cep,
	   Cli.codigo AS 'PK de Cliente',
	   Con.codigoCliente AS 'FK em Contato',
	   Con.numero,
	   Con.ramal,
	   Con.email,
	   Con.observacao
FROM Cliente AS Cli, 
     ClientePF AS PF,
	 Endereco AS E,
	 Contato AS Con
WHERE Cli.codigo = PF.codigoCliente
  AND Cli.codigoEndereco = E.codigo
  AND Cli.codigo = Con.codigoCliente


-- Atributos selecionados
SELECT Cli.nome_razaoSocial AS 'Nome',
	   IIF(Cli.nomeSocial_fantasia IS NULL, 'N�o informado', Cli.nomeSocial_fantasia)AS 'Nome social',
	   Cli.foto_logo AS 'Foto',
	   FORMAT(Cli.dataNascimento_abertura, 'd', 'pt-br') AS 'Data de nascimento',
	   PF.rg AS 'RG',
	   PF.cpf AS 'CPF',
	   E.logradouro,
	   E.bairro,
	   E.cidade,
	   E.uf,
	   Con.numero,
	   IIF(Con.ramal IS NULL, '', Con.ramal),
	   IIF(Con.email IS NULL, '', Con.email)
FROM Cliente AS Cli, 
     ClientePF AS PF,
	 Endereco AS E,
	 Contato AS Con
WHERE Cli.codigo = PF.codigoCliente
  AND Cli.codigoEndereco = E.codigo
  AND Cli.codigo = Con.codigoCliente
ORDER BY Nome


---------------------------------------------------------------------------------
-- JOINs (Jun��es)

-- ClientePJ (todos os atributos)
SELECT Cli.nome_razaoSocial AS 'Razao social',
	   Cli.nomeSocial_fantasia AS 'Nome fantasia',
	   Cli.foto_logo AS 'Logo',
	   FORMAT(Cli.dataNascimento_abertura, 'd', 'pt-br') AS 'Data de abertura',
	   Cli.usuario,
	   Cli.senha,
	   Cli.codigo AS 'PK de Cliente',
	   PJ.codigoCliente AS 'PK e FK de ClientePJ',
	   PJ.cnpj AS 'CNPJ',
	   PJ.inscricaoMunicipal AS 'IM',
	   PJ.inscricaoEstadual AS 'IE'
FROM Cliente AS Cli 
INNER JOIN ClientePJ AS PJ ON Cli.codigo = PJ.codigoCliente


-- ClientePJ (atributos selecionados)
SELECT Cli.nome_razaoSocial AS 'Razao social',
	   IIF(Cli.nomeSocial_fantasia IS NULL, 'N�o informado', Cli.nomeSocial_fantasia) AS 'Nome fantasia',
	   Cli.foto_logo AS 'Logo',
	   FORMAT(Cli.dataNascimento_abertura, 'd', 'pt-br') AS 'Data de abertura',
	   PJ.cnpj AS 'CNPJ',
	   PJ.inscricaoMunicipal AS 'IM',
	   IIF(PJ.inscricaoEstadual IS NULL, '', PJ.inscricaoEstadual) AS 'IE'
FROM Cliente AS Cli 
INNER JOIN ClientePJ AS PJ ON Cli.codigo = PJ.codigoCliente
WHERE PJ.inscricaoEstadual IS NOT NULL
ORDER BY Cli.nome_razaoSocial



-- ClientePF (todos os atributos)
SELECT Cli.nome_razaoSocial AS 'Nome',
	   IIF(Cli.nomeSocial_fantasia IS NULL, 'N�o informado', Cli.nomeSocial_fantasia)AS 'Nome social',
	   Cli.foto_logo AS 'Foto',
	   FORMAT(Cli.dataNascimento_abertura, 'd', 'pt-br') AS 'Data de nascimento',
	   Cli.usuario,
	   Cli.senha,
	   Cli.codigo AS 'PK de Cliente',
	   PF.codigoCliente AS 'PK e FK de ClientePF',
	   PF.rg AS 'RG',
	   PF.cpf AS 'CPF'
FROM Cliente AS Cli 
INNER JOIN ClientePF AS PF ON Cli.codigo = PF.codigoCliente



-- ClientePF (atributos selecionados)
SELECT Cli.nome_razaoSocial AS 'Nome',
	   IIF(Cli.nomeSocial_fantasia IS NULL, 'N�o informado', Cli.nomeSocial_fantasia)AS 'Nome social',
	   Cli.foto_logo AS 'Foto',
	   FORMAT(Cli.dataNascimento_abertura, 'd', 'pt-br') AS 'Data de nascimento',
	   PF.rg AS 'RG',
	   PF.cpf AS 'CPF'
FROM Cliente AS Cli
INNER JOIN ClientePF AS PF ON Cli.codigo = PF.codigoCliente
WHERE dataNascimento_abertura BETWEEN '01/01/1990' AND '31/12/1999'
ORDER BY Cli.dataNascimento_abertura


---------------------------------------------------------------------------------
-- LEFT JOIN

-- INNER JOIN
SELECT Con.agencia,
       Con.numero,
	   Con.tipo,
	   E.dataSolicitacao,
	   E.valorSolicitado
FROM Conta AS Con
INNER JOIN Emprestimo AS E ON Con.codigo = E.codigoConta


-- LEFT JOIN INCLUSIVE
SELECT Con.agencia,
       Con.numero,
	   Con.tipo,
	   E.dataSolicitacao,
	   E.valorSolicitado
FROM Conta AS Con
LEFT JOIN Emprestimo AS E ON Con.codigo = E.codigoConta


-- LEFT JOIN EXCLUSIVE
SELECT Con.agencia,
       Con.numero,
	   Con.tipo,
	   E.dataSolicitacao,
	   E.valorSolicitado
FROM Conta AS Con
LEFT JOIN Emprestimo AS E ON Con.codigo = E.codigoConta
WHERE E.codigoConta IS NULL



-- LEFT JOIN em relacionamento 1:1
SELECT Cli.nome_razaoSocial,
       PF.cpf,
	   PJ.cnpj
FROM Cliente AS Cli
LEFT JOIN ClientePF AS PF ON Cli.codigo = PF.codigoCliente
LEFT JOIN ClientePJ AS PJ ON Cli.codigo = PJ.codigoCliente


-------------------------------------------------------------------
-- Colunas geradas pela consulta

SELECT * FROM Conta
SELECT * FROM Emprestimo
SELECT * FROM EmprestimoParcela


SELECT Cont.agencia,
       Cont.numero,
	   E.dataAprovacao,
	   E.valorSolicitado,
	   E.juros,
	   E.valorSolicitado * E.juros AS 'Juros cobrado',
	   E.valorSolicitado + (E.valorSolicitado * E.juros) AS 'Valor total',
	   E.numeroParcela,
	   EP.numero,
	   EP.dataVencimento,
	   EP.valorParcela,
	   EP.valorPago
FROM Conta AS Cont
INNER JOIN Emprestimo AS E ON Cont.codigo = E.codigoConta
INNER JOIN EmprestimoParcela AS EP ON E.codigo = EP.codigoEmprestimo
WHERE Cont.codigo = 2

/* Observa��o:
   Mais exemplos de varia��es de JOINS no banco Livraria
*/


---------------------------------------------------------------------------------- 
-- Sub consultas (Sub Queries)

-- Consulta os investimentos com aporte acima da m�dia (de todos os aportes)
-- (Sub consulta em filtros de registros (linhas) retornando UM valor)

	-- Calculo da m�dia de aportes
	SELECT AVG(aporte) FROM Investimento

	-- Seleciona os registros a partir do resultado da sub consulta
	SELECT Con.agencia,
	       Con.numero,
		   I.tipo,
		   I.aporte
	FROM Conta AS Con
	INNER JOIN Investimento AS I ON Con.codigo = I.codigoConta
	WHERE I.aporte >= (SELECT AVG(aporte) FROM Investimento)
	ORDER BY I.aporte


-- Consulta os emprestimos de uma determinada conta apresentando o valor solicitado, 
-- o valor total a ser pago e o valor total j� pago
-- (Sub consulta em gera��o de novas coolunas)


	-- Calcula o valor j� pago
	SELECT SUM(EP.valorPago)
	FROM Conta AS Cont
	INNER JOIN Emprestimo AS E ON Cont.codigo = E.codigoConta
	INNER JOIN EmprestimoParcela AS EP ON E.codigo = EP.codigoEmprestimo
	WHERE Cont.codigo = 2 AND E.aprovado = 1


	-- Seleciona os atributos (colunas) complementando com uma coluna gerada por uma sub consulta
	SELECT Cont.agencia,
		   Cont.numero,
		   E.valorSolicitado,
		   E.juros,
		   E.valorSolicitado * E.juros AS 'Juros cobrado',
		   E.valorSolicitado + (E.valorSolicitado * E.juros) AS 'Valor total',

		   (SELECT SUM(EP.valorPago)
			FROM Conta AS Cont
			INNER JOIN Emprestimo AS E ON Cont.codigo = E.codigoConta
			INNER JOIN EmprestimoParcela AS EP ON E.codigo = EP.codigoEmprestimo
			WHERE Cont.codigo = 2 AND E.aprovado = 1) AS 'Total j� pago'

	FROM Conta AS Cont
	INNER JOIN Emprestimo AS E ON Cont.codigo = E.codigoConta
	WHERE Cont.codigo = 2 AND E.aprovado = 1




