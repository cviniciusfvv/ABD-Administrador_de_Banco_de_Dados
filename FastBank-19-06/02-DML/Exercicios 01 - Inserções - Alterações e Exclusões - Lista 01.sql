/*-----------------------------------------------
Banco: FastBank
Autor: Ralfe
Última alteração: 24/03/2023
Descrição: Exercícios de inserções, alterações e consultas
           iniciais/introdutórias - Lista 01
-----------------------------------------------*/

-- Conexão com o Banco
USE Fastbank
GO

SELECT * FROM Endereco
SELECT * FROM Cliente
SELECT * FROM Contato

-- 01. Insira dois endereços.
INSERT INTO Endereco
VALUES ('Rua Um, 123', 'Vila São João', 'Hortolândia', 'SP', '13180400'),
	   ('Rua Dois, 654', 'Vila Maria', 'Hortolândia', 'SP', '13180450')


-- 02. Insira um cliente com informações para todos os atributos (vinculado ao primeiro endereço que você inseriu).
INSERT INTO Cliente
VALUES (8, 'José da Silva', 'Zé', '\foto\123jpg', '24/03/1980', 'ze', 357)


-- 03. Insira um cliente sem o nomeSocial_fantasia (opcional) (vinculado ao segundo endereço que você inseriu).
INSERT INTO Cliente
	(codigoEndereco, nome_razaoSocial, foto_logo, dataNascimento_abertura, usuario, senha)
VALUES 
	(9, 'Maria da Silva', '\foto\321jpg', '20/02/1985', 'maria', 987)


-- 04. Altere o nomeSocial do cliente "Juan e Valentina Alimentos ME" para "Restaurante Avenida".
--SELECT * FROM Cliente
UPDATE Cliente
SET nomeSocial_fantasia = 'Restaurante Avenida'
WHERE nome_razaoSocial = 'Juan e Valentina Alimentos ME'


-- 05. Altere o nomeSocial do cliente "Regina e Julia Entregas Expressas ME" para "Entregas Express".
-- SELECT * FROM Cliente
UPDATE Cliente
SET nomeSocial_fantasia = 'Entregas Express'
WHERE nome_razaoSocial = 'Regina e Julia Entregas Expressas ME'


-- 06. Insira dois contatos completos (com valores para todos atributos) para o primeiro cliente que você inseriu.
INSERT INTO Contato
VALUES (8, '(19) 1234-9876', 'Ramal 3', 'jose@empresa.com', 'comercial')

INSERT INTO Contato
	(codigoCliente, numero, email, observacao)
VALUES 
	(8, '(19) 99875-9116', 'jose@hotmail.com', 'pessoal')


-- 07. Insira um contato com somente o numero de telefone para o segundo cliente que você inseriu.
INSERT INTO Contato
	(codigoCliente, numero)
VALUES 
	(9, '(11) 6598-3216')


-- 08. Altere o email jao@gmail.com para joao.bv@gmail.com.
-- SELECT * FROM Contato
-- WHERE email = 'jao@gmail.com'
UPDATE Contato
SET email = 'joao.bv@gmail.com'
WHERE codigo = 6


-- 09. Insira a observação "Horário comercial" no contato com telefone (18) 99771-7848 (alterando o registro já existente).
-- SELECT * FROM Contato
-- WHERE numero = '(18) 99771-7848'
UPDATE Contato
SET observacao = 'Horário comercial'
WHERE codigo = 5


-- 10. Exclua o primeiro endereço que você inseriu (executando quaisquer exclusões que sejam necessárias para isso).
--SELECT * FROM Endereco
DELETE FROM Endereco
WHERE codigo = 8
-- SELECT * FROM Cliente
DELETE FROM Cliente
WHERE codigo = 11


-- 11. Consulte os endereços (com todos os atributos) da cidade de São Paulo.
-- Correção de entrata errada
UPDATE Endereco
SET cidade = 'São Paulo' 
WHERE codigo = 6

SELECT *
FROM Endereco
WHERE cidade = 'São Paulo' 


-- 12. Consulte o bairro, cidade e uf dos endereços no bairro "Barão Geraldo".
SELECT bairro, 
       cidade, 
	   uf
FROM Endereco
WHERE bairro = 'Barão Geraldo' 


-- 13. Consulte o logradouro e o cep de endereços em avenidas.
SELECT logradouro, 
       cep
FROM Endereco
WHERE logradouro LIKE 'Avenida%'


-- 14. Consulte todos os atributos dos endereços com bairros que possuem a palavra Vila da cidade de São Paulo.
SELECT *
FROM Endereco
WHERE bairro LIKE 'Vila%' AND cidade = 'São Paulo'


-- 15. Consulte todos os atributos dos clientes que possuam as palavras ME ou Ltda no nome_razaoSocial.
SELECT *
FROM Cliente
WHERE nome_razaoSocial LIKE '%ME' OR nome_razaoSocial LIKE '%Ltda'


-- 16. Consulte o nome_razaoSocial dos clientes nascidos ou inaugurados na decada de 90.
SELECT *
FROM Cliente
WHERE dataNascimento_abertura BETWEEN '01/01/1990' AND '31/12/1999'


-- 17. Consulte somente os clientes que tenham nomeSocial_fantasia.
SELECT *
FROM Cliente
WHERE nomeSocial_fantasia IS NOT NULL


-- 18. Consulte os contatos (todos os atributos) que tenham ramal.
SELECT *
FROM Contato
WHERE ramal IS NOT NULL


-- 19. Consulte os números e e-mails com contatos que possuem e-mail do gmail.
SELECT *
FROM Contato
WHERE email LIKE '%gmail%'


-- 20. Consulte os contatos (todos os atributos) que ramal e observação.
SELECT *
FROM Contato
WHERE ramal IS NOT NULL AND observacao IS NOT NULL


