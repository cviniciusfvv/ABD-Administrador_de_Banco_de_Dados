/*-----------------------------------------------
Banco: FastBank
Autor: Ralfe
Última alteração: 27/03/2023
Descrição: Exercícios de consultas - Lista 01
-----------------------------------------------*/

-- Conexão com o Banco
USE Fastbank
GO

-- 1. (Emprestimo) Consulte a data de solicitação, valor solicitado e se o emprestimo foi "Aprovado" (quando 1) ou "Negado" (quando 0)
--    nomeando essa coluna como "Analise".

-- IIF(<condição>, <se for verdadeiro>, <se for falso>)

SELECT FORMAT(dataSolicitacao, 'd', 'pt-br') AS 'Data de solicitação',
       FORMAT(valorSolicitado, 'c', 'pt-br') AS 'Valor solicitado',
	   IIF(aprovado = 0, 'Negado', 'Aprovado') AS 'Analise'
FROM Emprestimo


-- 2. (Contato) Consulte todos os números de telefones e suas respectivas observações. Caso não haja observações apresente "Nada consta".

SELECT numero AS 'Números',
       IIF(observacao IS NULL, 'Nada consta', observacao ) AS 'Observações'
FROM Contato


-- 3. (Cartao) Consulte os numeros dos cartões, suas validades e bandeiras. 
--    Apresente o resultado em ordem crescente de bandeiras e para cada bandeira em ordem decrescente de validade

SELECT numero AS 'Número do cartão',
       bandeira AS 'Bandeira',
       FORMAT(validade, 'd', 'pt-br') AS 'Validade'
FROM Cartao
ORDER BY bandeira, validade DESC


-- 4. (Movimentacao) Consulte a operação e o valor dos três maiores creditos movimentados. Apresente os valores formatados como reais.

SELECT TOP(3) operacao AS 'Operações',
              FORMAT(valor, 'c', 'pt-br') AS 'Valor'
FROM Movimentacao
WHERE operacao = 'credito'
ORDER BY valor DESC


-- 5. (Investimentos) Qual o menor valor investido em ações.

SELECT FORMAT( MIN(aporte), 'c', 'pt-br') AS 'Aporte'
FROM Investimento
WHERE tipo = 'acoes'


-- 6. (Cliente) Consulte o nome, a data de nascimento/abertura e a idade (em anos) das pessoas e das empresas.

SELECT nome_razaoSocial AS 'Nome/ Razão social',
       FORMAT(dataNascimento_abertura, 'd', 'pt-br') AS 'Nascimento/Abertura',
	   DATEDIFF(YEAR, dataNascimento_abertura, GETDATE()) AS 'Anos'
FROM Cliente


-- 7. (EmprestimoParcela) Consulte quantas parcelas faltam para quitar o emprestimo de código 5.

SELECT COUNT(*) AS 'Parcelas não pagas'
FROM EmprestimoParcela
WHERE codigoEmprestimo = 3 AND dataPagamento IS NULL


-- 8. (Conta) Consulte o menor e o maior limite das contas correntes ativas.

SELECT FORMAT( MIN(limite), 'c', 'pt-br') AS 'Menor limite',
       FORMAT( MAX(limite), 'c', 'pt-br') AS 'Maior limite'
FROM Conta
WHERE tipo = 'corrente' AND ativa = 1

-- 9. (Movimentacao) Consulte a média de valores movimentados por operação. 

SELECT operacao AS 'Operação',
	   FORMAT(AVG(valor), 'c', 'pt-br') AS 'Média dos valores movimentados' 
FROM Movimentacao
GROUP BY operacao

-- 10. (EmprestimoParcela) Consulte os valores totais pagos em cada emprestimo.

SELECT codigoEmprestimo,
       FORMAT(SUM(valorPago), 'c', 'pt-br') AS 'Totais pagos' 
FROM EmprestimoParcela
-- WHERE dataPagamento IS NOT NULL
GROUP BY codigoEmprestimo
