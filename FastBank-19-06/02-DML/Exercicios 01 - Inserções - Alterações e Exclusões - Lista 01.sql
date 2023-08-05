/*-----------------------------------------------
Banco: FastBank
Autor: Ralfe
�ltima altera��o: 24/03/2023
Descri��o: Exerc�cios de inser��es, altera��es e consultas
           iniciais/introdut�rias - Lista 01
-----------------------------------------------*/

-- Conex�o com o Banco
USE Fastbank
GO

SELECT * FROM Endereco
SELECT * FROM Cliente
SELECT * FROM Contato

-- 01. Insira dois endere�os.
INSERT INTO Endereco
VALUES ('Rua Um, 123', 'Vila S�o Jo�o', 'Hortol�ndia', 'SP', '13180400'),
	   ('Rua Dois, 654', 'Vila Maria', 'Hortol�ndia', 'SP', '13180450')


-- 02. Insira um cliente com informa��es para todos os atributos (vinculado ao primeiro endere�o que voc� inseriu).
INSERT INTO Cliente
VALUES (8, 'Jos� da Silva', 'Z�', '\foto\123jpg', '24/03/1980', 'ze', 357)


-- 03. Insira um cliente sem o nomeSocial_fantasia (opcional) (vinculado ao segundo endere�o que voc� inseriu).
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


-- 06. Insira dois contatos completos (com valores para todos atributos) para o primeiro cliente que voc� inseriu.
INSERT INTO Contato
VALUES (8, '(19) 1234-9876', 'Ramal 3', 'jose@empresa.com', 'comercial')

INSERT INTO Contato
	(codigoCliente, numero, email, observacao)
VALUES 
	(8, '(19) 99875-9116', 'jose@hotmail.com', 'pessoal')


-- 07. Insira um contato com somente o numero de telefone para o segundo cliente que voc� inseriu.
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


-- 09. Insira a observa��o "Hor�rio comercial" no contato com telefone (18) 99771-7848 (alterando o registro j� existente).
-- SELECT * FROM Contato
-- WHERE numero = '(18) 99771-7848'
UPDATE Contato
SET observacao = 'Hor�rio comercial'
WHERE codigo = 5


-- 10. Exclua o primeiro endere�o que voc� inseriu (executando quaisquer exclus�es que sejam necess�rias para isso).
--SELECT * FROM Endereco
DELETE FROM Endereco
WHERE codigo = 8
-- SELECT * FROM Cliente
DELETE FROM Cliente
WHERE codigo = 11


-- 11. Consulte os endere�os (com todos os atributos) da cidade de S�o Paulo.
-- Corre��o de entrata errada
UPDATE Endereco
SET cidade = 'S�o Paulo' 
WHERE codigo = 6

SELECT *
FROM Endereco
WHERE cidade = 'S�o Paulo' 


-- 12. Consulte o bairro, cidade e uf dos endere�os no bairro "Bar�o Geraldo".
SELECT bairro, 
       cidade, 
	   uf
FROM Endereco
WHERE bairro = 'Bar�o Geraldo' 


-- 13. Consulte o logradouro e o cep de endere�os em avenidas.
SELECT logradouro, 
       cep
FROM Endereco
WHERE logradouro LIKE 'Avenida%'


-- 14. Consulte todos os atributos dos endere�os com bairros que possuem a palavra Vila da cidade de S�o Paulo.
SELECT *
FROM Endereco
WHERE bairro LIKE 'Vila%' AND cidade = 'S�o Paulo'


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


-- 19. Consulte os n�meros e e-mails com contatos que possuem e-mail do gmail.
SELECT *
FROM Contato
WHERE email LIKE '%gmail%'


-- 20. Consulte os contatos (todos os atributos) que ramal e observa��o.
SELECT *
FROM Contato
WHERE ramal IS NOT NULL AND observacao IS NOT NULL


