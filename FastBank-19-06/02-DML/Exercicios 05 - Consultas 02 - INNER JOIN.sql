/*--------------------------------------------------------
Banco: FastBank
Autor: Ralfe
�ltima altera��o: 03/04/2023 �s 22:45
Descri��o: Exerc�cios de consultas - Lista 02 - INNER JOIN
---------------------------------------------------------*/

-- Conex�o com o Banco
USE Fastbank
GO

-- 01. Todas as contas e os investimentos existentes

SELECT Con.agencia,
       Con.numero,
	   I.tipo,
	   I.aporte
FROM Conta AS Con
INNER JOIN Investimento AS I ON Con.codigo = I.codigoConta


SELECT Con.agencia,
       Con.numero,
	   I.tipo,
	   I.aporte
FROM Conta AS Con
LEFT JOIN Investimento AS I ON Con.codigo = I.codigoConta


-- 02. Todos os cart�es e as movimenta��es realizadas

SELECT Car.numero,
       Car.bandeira,
	   Mov.dataHora,
	   Mov.operacao,
	   Mov.valor
FROM Cartao AS Car
INNER JOIN Movimentacao AS Mov ON Car.codigo = Mov.codigoCartao


SELECT Car.numero,
       Car.bandeira,
	   Mov.dataHora,
	   Mov.operacao,
	   Mov.valor
FROM Cartao AS Car
LEFT JOIN Movimentacao AS Mov ON Car.codigo = Mov.codigoCartao
ORDER BY Mov.dataHora


-- 3. Todos os emprestimos e as parcelas existentes

SELECT E.codigo,
       E.dataSolicitacao,
       E.valorSolicitado,
	   E.aprovado,
	   P.numero,
	   P.dataVencimento,
	   P.valorParcela
FROM Emprestimo AS E
INNER JOIN EmprestimoParcela AS P ON E.codigo = P.codigoEmprestimo


SELECT E.codigo,
       E.dataSolicitacao,
       E.valorSolicitado,
	   E.aprovado,
	   P.numero,
	   P.dataVencimento,
	   P.valorParcela
FROM Emprestimo AS E
LEFT JOIN EmprestimoParcela AS P ON E.codigo = P.codigoEmprestimo
ORDER BY E.aprovado, E.codigo



-----------------------------------------------------------------------------------------------
-- Conex�o com o Banco
USE Fastbank
GO

-- 01. Consulte todos os clientes (nome) e seus respectivos endere�os (logradouro, cidade e uf)

SELECT Cli.nome_razaoSocial,
       -- Cli.codigoEndereco,
	   -- E.codigo,
       E.logradouro,
	   E.cidade,
	   E.uf
FROM Cliente AS Cli
INNER JOIN Endereco AS E ON Cli.codigoEndereco = E.codigo
ORDER BY E.logradouro


-- 02. Consulte todos os clientes (nome) e seus respectivos contatos (numero e email)

SELECT Cli.nome_razaoSocial,
       -- Cli.codigo,
	   -- Con.codigoCliente,
       Con.numero AS 'Telefone',
	   IIF(Con.email IS NULL, '', Con.email) As 'E-mail'
FROM Cliente AS Cli
INNER JOIN Contato AS Con ON Cli.codigo = Con.codigoCliente
ORDER BY Cli.nome_razaoSocial


-- 03. Consulte todas as contas (agencia, numero e tipo) e seus respectivos cart�es (numero e bandeira)

SELECT Con.agencia,
       Con.numero,
	   Con.tipo,
	   -- Con.codigo,
	   -- Car.codigoConta,
	   Car.numero,
	   Car.bandeira
FROM Conta AS Con
INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta 
ORDER BY Con.agencia, Con.numero, Car.numero


-- 04. Consulte todas as contas (agencia, numero e tipo) e seus respectivos emprestimos (data solicita��o, valor solicitado e se foi aprovado ou n�o)

SELECT C.agencia,
       C.numero,
	   C.tipo,
	   -- C.codigo,
	   -- E.codigoConta,
	   FORMAT(E.dataSolicitacao, 'd', 'pt-br') AS 'Data solicita��o',
	   FORMAT(E.valorSolicitado, 'C', 'pt-br') AS 'Valor solicitado', 
	   IIF(E.aprovado = 1, 'Sim', 'N�o') AS 'Aprovado'
FROM Conta AS C
INNER JOIN Emprestimo AS E ON C.codigo = E.codigoConta
ORDER BY C.agencia, C.numero, E.dataSolicitacao, E.valorSolicitado


-- 05. Consulte todas as contas (agencia, numero e tipo) e seus respectivos investimentos (tipo e aporte)

SELECT C.agencia,
       C.numero,
	   C.tipo,
	   -- C.codigo,
	   -- I.codigoConta,
	   I.tipo,
	   FORMAT(I.aporte, 'C', 'pt-br') AS 'Valor aporte'
FROM Conta AS C
INNER JOIN Investimento AS I ON C.codigo = I.codigoConta
ORDER BY C.agencia, C.numero

-- 06. Consulte o cart�o numero 4444695847251436 (numero e bandeira) e suas movimenta��es (data, opera��o e valor)

SELECT C.numero,
       C.bandeira,
	   -- C.codigo,
	   -- M.codigoCartao,
	   FORMAT(M.dataHora, 'd', 'pt-br') AS 'Data e hora da movimenta��o',
	   M.operacao,
	   FORMAT(M.valor, 'C', 'pt-br') AS 'Valor da movimenta��o'
FROM Cartao AS C
INNER JOIN Movimentacao AS M ON C.codigo = M.codigoCartao
WHERE C.numero = '4444695847251436'


-- 07. Consulte o emprestimo de codigo 2 (data solicita��o, valor solicitado e numero de parcelas) e suas parcelas em aberto (n�o pagas) (n�mero, valor e data de vencimento)

SELECT FORMAT(E.dataSolicitacao, 'd', 'pt-br') AS 'Data solicita��o',
       FORMAT(E.valorSolicitado, 'c', 'pt-br') AS 'Valor solicitado',
	   E.numeroParcela,
	   -- E.codigo,
	   -- P.codigoEmprestimo,
	   P.numero,
	   FORMAT(P.valorParcela, 'c', 'pt-br') AS 'Valor parcela',
	   FORMAT(P.dataVencimento, 'd', 'pt-br') AS 'Data vencimento'
	   -- P.valorPago
FROM Emprestimo AS E
INNER JOIN EmprestimoParcela AS P ON E.codigo = P.codigoEmprestimo
WHERE E.codigo = 2 AND P.valorPago IS NULL


-- 08. Consulte os clientes (nome) e seus respectivos endere�os (logradouro, cidade e uf) que moram na cidade de S�o Paulo

SELECT C.nome_razaoSocial,
       E.logradouro,
	   E.cidade,
	   E.uf
FROM Cliente AS C
INNER JOIN Endereco AS E ON C.codigoEndereco = E.codigo
WHERE E.cidade = 'S�o Paulo'
ORDER BY E.logradouro


-- 09. Consulte os clientes (nome) e seus respectivos contatos (numero e email) dos cliente que tem e-mail do gmail

SELECT Cli.nome_razaoSocial,
       -- Cli.codigo,
	   -- Con.codigoCliente,
	   Con.numero,
	   Con.email
FROM Cliente AS Cli
INNER JOIN Contato AS Con ON Cli.codigo = Con.codigoCliente
WHERE Con.email LIKE '%gmail%'
ORDER BY Cli.nome_razaoSocial


-- 10. Consulte as contas (agencia, numero e tipo) que possuem investimentos de longo prazo (tipo, aporte e prazo)

SELECT C.agencia,
       C.numero,
	   C.tipo AS 'Tipo de Conta',
	   -- C.codigo,
	   -- I.codigoConta,
	   I.tipo AS 'Tipo de Investimento',
	   FORMAT(I.aporte, 'c', 'pt-br') AS 'Valor parcela',
	   I.prazo
FROM Conta AS C
INNER JOIN Investimento AS I ON C.codigo = I.codigoConta
WHERE I.prazo = 'longo'


-- 11. Consulte quem � cliente (nome) que possui o telefone (11) 98052-6863

SELECT Cli.nome_razaoSocial,
       -- Cli.codigo,
	   -- Con.codigoCliente,
       Con.numero
FROM Cliente AS Cli
INNER JOIN Contato AS Con ON Cli.codigo = Con.codigoCliente
WHERE Con.numero = '(11) 98052-6863'

-- 12. Quais contas (agencia, numero e tipo) tiveram seus emprestimos negados (data solicita��o, valor solicitado e se foi aprovado ou n�o)

SELECT C.agencia,
       C.numero,
	   C.tipo,
	   -- C.codigo,
	   -- E.codigoConta,
	   FORMAT(E.dataSolicitacao, 'd', 'pt-br') AS 'Data solicita��o',
	   FORMAT(E.valorSolicitado, 'C', 'pt-br') AS 'Valor solicitado',
	   IIF(E.aprovado = 1, 'Sim', 'N�o') AS 'Aprovado'
FROM Conta AS C
INNER JOIN Emprestimo AS E ON C.codigo = E.codigoConta
WHERE E.aprovado = 0


-- 14. Quais foram os cart�es (numero e bandeira) que realizaram movimenta��es no dia 01/02/2023 (data, opera��o e valor)

SELECT C.numero,
       C.bandeira,
	   -- C.codigo,
	   -- M.codigoCartao,
	   M.dataHora,
	   M.operacao,
	   FORMAT(M.valor, 'C', 'pt-br') AS 'Valor'
FROM Cartao AS C
INNER JOIN Movimentacao AS M ON C.codigo = M.codigoCartao
WHERE FORMAT(M.dataHora, 'd', 'pt-br') = '01/02/2023'
-- WHERE CAST(M.dataHora AS DATE) = '01/02/2023'
ORDER BY C.numero, C.bandeira, M.dataHora





-- 15. Consulte os clientes PJ (nome e CNPJ) e suas respectivas cidades e telefone de contato

SELECT Cli.nome_razaoSocial,
	   -- Cli.codigo AS 'PK Cliente',
	   -- PJ.codigoCliente AS 'FK ClientePJ',
       PJ.cnpj,
	   -- Cli.codigoEndereco AS 'FK Cliente',
	   -- E.codigo AS 'PK Endereco',
	   E.cidade,
	   -- Cli.codigo AS 'PK Cliente',
	   -- Con.codigoCliente AS 'FK Contato',
	   Con.numero
FROM Cliente AS Cli
INNER JOIN ClientePJ AS PJ ON Cli.codigo = PJ.codigoCliente
INNER JOIN Endereco AS E ON Cli.codigoEndereco = E.codigo
INNER JOIN Contato AS Con ON Cli.codigo = Con.codigoCliente


-- 16. Consulte as contas (agencia e numero) seus cart�es (numero e bandeira) e suas respectivas movimenta��es (operacao e valor) 

SELECT Con.agencia,
       Con.numero,
	   -- Con.codigo,
	   -- Car.codigoConta,
	   Car.numero,
	   Car.bandeira,
	   -- Car.codigo,
	   -- Mov.codigoCartao,
	   Mov.operacao,
	   Mov.valor
FROM Conta AS Con
INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta
INNER JOIN Movimentacao AS Mov ON Car.codigo = Mov.codigoCartao
ORDER BY Con.agencia, Con.numero, Car.numero, Mov.operacao


-- 17. Consulte as contas (agencia e numero) seus emprestimos (codigos, datas de solicita��o e valores solicitados) 
--     e suas respectivas parcelas (numero, vencimento e valor pago)

SELECT C.agencia,
       C.numero,
	   -- C.codigo,
	   -- E.codigoConta,
	   E.codigo,
	   E.dataSolicitacao,
	   E.valorSolicitado,
	   -- E.codigo,
	   -- P.codigoEmprestimo,
	   P.numero,
	   P.dataVencimento,
	   P.valorPago
FROM Conta AS C
INNER JOIN Emprestimo AS E ON C.codigo = E.codigoConta
INNER JOIN EmprestimoParcela AS P ON E.codigo = P.codigoEmprestimo


-- 18. Consulte todos clientes pessoa f�sica (nome e cpf) e suas respectivas contas (agencia, numero)

SELECT Cli.nome_razaoSocial,
       PF.cpf,
	   Con.agencia,
	   Con.numero,
	   Con.tipo
FROM Cliente AS Cli
INNER JOIN ClientePF AS PF ON Cli.codigo = PF.codigoCliente
INNER JOIN ClienteConta AS CC ON Cli.codigo = CC.codigoCliente
INNER JOIN Conta AS Con ON CC.codigoConta = Con.codigo
-- ORDER BY Cli.nome_razaoSocial
ORDER BY Con.agencia, Con.numero

-- 19. Consulte as transfer�ncias (com valores) realizadas pela cliente Abigail Barateiro Cangueiro

SELECT Cli.nome_razaoSocial,
       -- Con.agencia,
	   -- Con.numero,
	   -- Car.numero,
	   -- Car.bandeira,
	   Mov.operacao,
	   Mov.valor
FROM Cliente AS Cli
INNER JOIN ClienteConta AS CC ON Cli.codigo = CC.codigoCliente
INNER JOIN Conta AS Con ON CC.codigoConta = Con.codigo
INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta
INNER JOIN Movimentacao AS Mov ON Car.codigo = Mov.codigoCartao
WHERE Cli.codigo = 3 AND Mov.operacao = 'transferencia'

/*
SELECT * 
FROM Cliente
WHERE nome_razaoSocial = 'Abigail Barateiro Cangueiro'
*/

-- 20. Consulte as opera��es de cr�dito e debito (com valores) realizadas pela cliente Alice Barbalho Vilalobos

SELECT Cli.nome_razaoSocial,
       Mov.operacao,
	   Mov.valor
FROM Cliente AS Cli
INNER JOIN ClienteConta AS CC ON Cli.codigo = CC.codigoCliente
INNER JOIN Conta AS Con ON CC.codigoConta = Con.codigo
INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta
INNER JOIN Movimentacao AS Mov ON Car.codigo = Mov.codigoCartao
-- WHERE Cli.codigo = 1 AND (Mov.operacao = 'debito' OR Mov.operacao = 'credito')
-- WHERE Cli.codigo = 1 AND Mov.operacao != 'transferencia'
WHERE Cli.codigo = 1 AND Mov.operacao <> 'transferencia'
ORDER BY Mov.operacao


/*
SELECT * 
FROM Cliente
WHERE nome_razaoSocial = 'Alice Barbalho Vilalobos'
*/

-- 21. Consulte quais clientes (nomes) realizaram movimenta��es em 01/02/2023


SELECT DISTINCT Cli.nome_razaoSocial,
                FORMAT(CAST(Mov.dataHora AS DATE), 'd', 'pt-br') AS 'Data'
FROM Cliente AS Cli
INNER JOIN ClienteConta AS CC ON Cli.codigo = CC.codigoCliente
INNER JOIN Conta AS Con ON CC.codigoConta = Con.codigo
INNER JOIN Cartao AS Car ON Con.codigo = Car.codigoConta
INNER JOIN Movimentacao AS Mov ON Car.codigo = Mov.codigoCartao
WHERE CAST(Mov.dataHora AS DATE) = '01/02/2023'


-- 22. Consulte os clientes (nome) que possuem emprestimos aprovados apresentando os valores solicitados e os valores totais que ser�o pagos (com juros)

SELECT Cli.nome_razaoSocial AS 'Nome/Raz�o social',
       FORMAT(E.valorSolicitado, 'C', 'pt-br') AS 'Valor solicitado',
	   FORMAT((E.valorSolicitado * E.juros), 'C', 'pt-br') AS 'Juros cobrado',
	   FORMAT(E.valorSolicitado + (E.valorSolicitado * E.juros), 'C', 'pt-br') AS 'Valor total'
FROM Cliente AS Cli
INNER JOIN ClienteConta AS CC ON Cli.codigo = CC.codigoCliente
INNER JOIN Conta AS Con ON CC.codigoConta = Con.codigo
INNER JOIN Emprestimo AS E ON Con.codigo = E.codigoConta
WHERE E.aprovado = 1

