/*-----------------------------------------------
Banco: FastBank
Autor: Ralfe
Última alteração: 12/04/2023 - 21:00
Descrição: Inserções de dados iniciais pra testes
-----------------------------------------------*/
/* Mais informações sobre:

	Integridade referencial
	https://www.devmedia.com.br/integridade-de-dados-parte-01/8831
*/

-- Conexão com o Banco
USE Fastbank
GO


INSERT INTO Endereco
	(logradouro, bairro, cidade, uf, cep)
VALUES
	('Avenida São João, 156', 'Vila Joana', 'Jundiaí', 'SP', '13216000'),
	('Rua Paracatu, 698', 'Parque Imperial', 'São Paulo', 'SP', '04302021'),
	('Avenida Cristiano Olsen, 10', 'Jardim Sumaré', 'Araçatuba', 'SP', '16015244'),
	('Rua Serra de Bragança, 74', 'Vila Gomes Cardim', 'São Paulo', 'SP', '03318000'),
	('Rua Barao de Vitoria, 65', 'Casa Grande', 'Diadema', 'SP',	'09961660'),
	('Rua Pereira Estefano, 100', 'Vila da Saúde', 'São Paulo', 'SP', '04144070'),
	('Alameda do Carmo, 15', 'Barão Geraldo', 'Campinas', 'SP', '13084008')

-- SELECT * FROM Endereco
GO


INSERT INTO Cliente
	(codigoEndereco, nome_razaoSocial, nomeSocial_fantasia, foto_logo, dataNascimento_abertura, usuario, senha)
VALUES
	(1, 'Alice Barbalho Vilalobos', 'Alice Vilalobos', '\fotos\2.jpg', '17/05/1992', 'alice', 987),
	(2, 'Sheila Tuna Espírito Santo', NULL, '\fotos\4.jpg', '05/03/1980', 'sheila', 123),
	(3, 'Abigail Barateiro Cangueiro', NULL, '\fotos\6.jpg', '30/05/1987', 'abigail', 147),
	(4, 'Regina e Julia Entregas Expressas ME', NULL, '\fotos\8.jpg', '11/03/2018', 'express', 987),
	(1, 'João Barbalho Vilalobos', NULL, '\fotos\10.jpg', '15/06/1990', 'joao', 357),
	(5, 'Juan e Valentina Alimentos ME', NULL, '\fotos\12.jpg','12/11/2015', 'avenida', 258),
	(6, 'Derek Bicudo Lagos', NULL, '\fotos\14.jpg', '12/03/2002', 'derek', 258),
	(7, 'Marcelo Frois Caminha', 'Ana Maria', '\fotos\16.jpg', '23/11/2001', 'ana', 654),
	(7, 'Gabriel e Marcelo Corretores Associados Ltda', 'Imobiliária Cidade', '\fotos\18.jpg', '26/09/2017', 'cidade', 474),
	(5, 'Jaime Câmara Valério', NULL, '\fotos\20.jpg', '20/07/1998', 'jaime', 369)

-- SELECT * FROM Cliente
GO


INSERT INTO Contato
	(codigoCliente,	numero, ramal, email, observacao)
VALUES
	(1, '(15)  3754-8198', 'Ramal 12', 'alicebv@yahoo.com','Comercial'),
	(1, '(13) 98872-3866', NULL, NULL, 'Pessoal'),
	(2, '(11)  3836-8266', NULL, 'sheila.santo@uol.com', NULL),
	(3, '(11)  2605-8626', NULL, 'abigail.vilalobos@gmail.com', NULL),
	(4, '(18) 99771-7848', NULL, 'express@gmail.com', NULL),
	(5, '(16) 99184-1137', NULL, 'jao@gmail.com', NULL),		
	(6, '(11) 96905-6363', NULL, 'avenida@hotmail.com', 'Horário comercial'),
	(7, '(19)  2389-8133', 'Ramal 10', 'derek.bc@empresa.com', NULL),
	(7, '(11) 98052-6863', NULL, 'derek.bc@gmail.com', 'Trabalho'),
	(8, '(14)  2355-4677', 'Ramal 2', 'marcelofrois@gmail.com', 'Comercial'),
	(8, '(18) 99890-3946', NULL, 'marcelofrois@uol.com', 'Trabalho'),
	(9, '(11)  3456-2642', NULL, 'cidade@gmail.com', 'Escritório'),
	(9, '(17) 97222-1107', NULL, NULL, 'Corretor'),
	(10, '(18) 99874-9845', NULL, NULL, 'Pessoal'),
	(10, '(19)  2533-3554', NULL, 'jaimecamara@hotmail.com', NULL)

-- SELECT * FROM Contato
GO


INSERT INTO ClientePF
	(codigoCliente, cpf, rg)
VALUES
	(1, '33474720040', '135769735'),
	(2, '25964866018', '159052075'),
	(3, '56069215028', '129752927'),
	(5, '91039176062', '358350293'),
	(7, '41396396012', '383172391'),
	(8, '41396396013', '383172392'),
	(10, '41396396014', '383172393')

-- SELECT * FROM Cliente, ClientePF
-- WHERE Cliente.codigo = ClientePF.codigoCliente
GO


INSERT INTO ClientePJ
	(codigoCliente, cnpj, inscricaoMunicipal, inscricaoEstadual)
VALUES
	(4, '41100430000162', '652348.265.32', '804.332.566.351'),
	(6, '92532245000188', '258463.147.96', '568.016.087.935'),
	(9, '78802521000150', '458698.123.89', NULL)

-- SELECT * FROM Cliente, ClientePJ
-- WHERE Cliente.codigo = ClientePJ.codigoCliente
GO


INSERT INTO Conta
	(agencia, numero, tipo, limite, ativa)
VALUES
	('01470', '1234568', 'corrente', '3000.00', 1),
	('02582', '6549872', 'corrente', '4000.00', 1),
/**/('03695', '4567893', 'investimento', '0.00', 0),
	('02582', '2583697', 'corrente', '5000.00', 1),
	('02582', '1472580', 'investimento', '0.00', 1),
	('01470', '2648591', 'investimento', '0.00' ,1),
	('01470', '1548789', 'corrente', '3500.00', 1),
/**/('02582', '2315487', 'corrente', '4000.00', 0)

-- SELECT * FROM Conta
GO


INSERT INTO Cartao
	(codigoConta, numero, cvv, validade, bandeira, situacao)
VALUES
	(1, '2233475802364659', '321', '01/03/2025', 'Visa', 'ativo'),
/**/(2, '3333457811659329', '654', '01/05/2028', 'MasterCard', 'bloqueado'),
/**/(2, '2828453678963265', '987', '01/01/2022', 'Elo', 'vencido'),
	(3, '4444695847251436', '369', '01/06/2026', 'American Express', 'ativo'),
/**/(4, '6969625134286178', '258', '01/01/2023', 'Visa', 'vencido'),
	(5, '2356458965213497', '147', '01/07/2025', 'Elo', 'ativo'),
	(4, '7777653298456325', '983', '01/06/2026', 'MasterCard', 'ativo'),
	(5, '1326456952148569', '984', '01/03/2025', 'Visa', 'ativo'),
	(6, '2654684768766648', '456', '01/04/2025', 'MasterCard', 'ativo'),
	(7, '2165468743513635', '756', '01/04/2025', 'Visa', 'ativo')

-- SELECT * FROM Cartao
GO


INSERT INTO Movimentacao
	(codigoCartao, codigoContaDestino, dataHora, operacao, valor)
VALUES
	(1, NULL, '01/02/2023 07:30:00', 'debito', 1000.00),
	(9, NULL, '01/02/2023 08:15:20', 'credito', 2500.00),
	(4, NULL, '01/02/2023 14:05:10', 'credito', 3450.00),
	(10, 2,   '01/02/2023 16:45:26', 'transferencia', 1100.00),
	(4, NULL, '01/02/2023 18:50:00', 'debito', 950.00),
	(1, NULL, '01/02/2023 20:00:30', 'credito', 546.00),
	(4, 7,    '01/02/2023 22:13:47', 'transferencia', 5000.00),
	(4, NULL, '02/02/2023 07:45:10', 'credito', 3600.00),
	(6, NULL, '02/02/2023 09:14:44', 'debito', 2800.00),
	(7, 1,    '02/02/2023 11:30:12', 'transferencia', 750.00),
	(7, NULL, '02/02/2023 13:13:00', 'credito', 500.00),
	(6, NULL, '02/02/2023 15:30:07', 'debito', 9000.00),
	(7, NULL, '02/02/2023 16:25:00', 'credito', 2350.00),
	(8, NULL, '02/02/2023 21:05:55', 'debito', 6400.00),
	(8, 4,    '02/02/2023 21:48:36', 'transferencia', 2100.00),
	(8, NULL, '03/02/2023 07:15:00', 'debito', 600.00),
	(1, NULL, '03/02/2023 07:36:15', 'debito', 1750.00),
	(1, NULL, '03/02/2023 08:05:55', 'credito', 900.00),
	(8, NULL, '03/02/2023 08:30:00', 'debito', 4000.00),
	(10, 4,   '03/02/2023 10:00:00', 'transferencia', 5500.00),
	(9, NULL, '03/02/2023 12:15:00', 'credito', 360.00),
	(8, 6,    '03/02/2023 14:20:45', 'transferencia', 600.00),
	(7, NULL, '03/02/2023 14:50:40', 'debito', 3800.00),
	(6, NULL, '03/02/2023 14:29:30', 'credito', 2000.00),
	(1, 6,    '03/02/2023 15:00:20', 'transferencia', 850.00),
	(6, NULL, '03/02/2023 16:05:00', 'debito', 660.00),
	(5, NULL, '03/02/2023 18:35:15', 'debito', 780.00),
	(8, NULL, '04/02/2023 07:15:00', 'debito', 600.00),
	(1, NULL, '04/02/2023 07:36:15', 'debito', 1750.00),
	(1, NULL, '04/02/2023 08:05:55', 'credito', 900.00),
	(8, NULL, '04/02/2023 08:30:00', 'debito', 4000.00),
	(9, 1,    '04/02/2023 10:00:00', 'transferencia', 5500.00),
	(7, NULL, '04/02/2023 12:15:00', 'credito', 360.00),
	(8, 2,    '04/02/2023 14:20:45', 'transferencia', 600.00),
	(7, NULL, '04/02/2023 14:50:40', 'debito', 3800.00),
	(6, NULL, '04/02/2023 14:29:30', 'credito', 2000.00),
	(8, NULL, '05/02/2023 08:15:00', 'debito', 370.00),
	(1, NULL, '05/02/2023 08:36:15', 'debito', 1750.00),
	(1, NULL, '05/02/2023 09:05:55', 'credito', 2900.00),
	(8, NULL, '05/02/2023 09:30:00', 'debito', 450.00),
	(10, 4,   '05/02/2023 09:00:00', 'transferencia', 5800.00),
	(10, NULL,'05/02/2023 09:15:00', 'credito', 2360.00),
	(8, 6,    '05/02/2023 10:20:45', 'transferencia', 1600.00),
	(7, NULL, '05/02/2023 10:25:40', 'debito', 330.00),
	(6, NULL, '05/02/2023 10:29:30', 'credito', 2900.00),
	(8, NULL, '05/02/2023 16:15:00', 'debito', 3500.00),
	(1, NULL, '05/02/2023 16:36:15', 'debito', 1050.00),
	(1, NULL, '05/02/2023 18:05:55', 'credito', 7400.00),
	(8, NULL, '05/02/2023 19:30:00', 'debito', 6000.00),
	(8, 4,    '05/02/2023 20:00:00', 'transferencia', 1280.00),
	(6, NULL, '05/02/2023 22:15:00', 'credito', 690.00),
	(8, 2,    '05/02/2023 22:20:45', 'transferencia', 1450.00),
	(7, NULL, '05/02/2023 23:50:40', 'debito', 26800.00),
	(6, NULL, '05/02/2023 23:55:30', 'credito', 900.00)

-- SELECT * FROM Movimentacao
GO


INSERT INTO Emprestimo
	(codigoConta, dataSolicitacao, valorSolicitado, juros, aprovado, numeroParcela, dataAprovacao, observacao)
VALUES
	(1, '10/10/2022', 10000.00, 0.05, 1, 10, '16/10/2022', NULL),
	(2, '15/11/2022', 15000.00, 0.05, 1, 12, '17/11/2022', 'Consignado'),
	(2, '05/12/2022', 25000.00, 0.065, 0, 0, NULL, 'Recusado'),
	(3, '10/12/2022', 12000.00, 0.05, 0, 0,  NULL, 'Recusado'),
	(5, '10/01/2023', 15000.00, 0.1, 1, 24, '13/01/2023', 'Consignado')

-- SELECT * FROM Emprestimo
GO


INSERT INTO EmprestimoParcela
	(codigoEmprestimo, numero, dataVencimento, valorParcela, dataPagamento, valorPago)
VALUES
	(1, 1, '15/11/2022', 1050.00, '14/11/2022', 1050.00),
	(1, 2, '15/12/2022', 1050.00, '15/12/2022', 1050.00),
	(1, 3, '15/01/2023', 1050.00, '16/01/2023', 1050.00),
	(1, 4, '15/02/2023', 1050.00, '15/02/2023', 1050.00),
	(1, 5, '15/03/2023', 1050.00, '14/03/2023', 1050.00),
	(1, 6, '15/04/2023', 1050.00, NULL, NULL),
	(1, 7, '15/05/2023', 1050.00, NULL, NULL),
	(1, 8, '15/06/2023', 1050.00, NULL, NULL),
	(1, 9, '15/07/2023', 1050.00, NULL, NULL),
	(1, 10, '15/08/2023', 1050.00, NULL, NULL),
	(2, 1, '10/12/2022', 1312.50, '10/12/2022', 1312.50),
	(2, 2, '10/01/2023', 1312.50, '12/01/2023', 1312.50),
	(2, 3, '10/02/2023', 1312.50, '11/02/2023', 1312.50),
	(2, 4, '10/03/2023', 1312.50, '09/03/2023', 1312.50),
	(2, 5, '10/04/2023', 1312.50, NULL, NULL),
	(2, 6, '10/05/2023', 1312.50, NULL, NULL),
	(2, 7, '10/06/2023', 1312.50, NULL, NULL),
	(2, 8, '10/07/2023', 1312.50, NULL, NULL),
	(2, 9, '10/08/2023', 1312.50, NULL, NULL),
	(2, 10, '10/09/2023', 1312.50, NULL, NULL),
	(2, 11, '10/10/2023', 1312.50, NULL, NULL),
	(2, 12, '10/11/2023', 1312.50, NULL, NULL),
	(5, 1, '10/02/2023', 687.50, '10/02/2023', 687.50),
	(5, 2, '10/03/2023', 687.50, '08/03/2023', 687.50),
	(5, 3, '10/04/2023', 687.50, NULL, NULL),
	(5, 4, '10/05/2023', 687.50, NULL, NULL),
	(5, 5, '10/06/2023', 687.50, NULL, NULL),
	(5, 6, '10/07/2023', 687.50, NULL, NULL),
	(5, 7, '10/08/2023', 687.50, NULL, NULL),
	(5, 8, '10/09/2023', 687.50, NULL, NULL),
	(5, 9, '10/10/2023', 687.50, NULL, NULL),
	(5, 10, '10/11/2023', 687.50, NULL, NULL),
	(5, 11, '10/12/2023', 687.50, NULL, NULL),
	(5, 12, '10/01/2024', 687.50, NULL, NULL),
	(5, 13, '10/02/2024', 687.50, NULL, NULL),
	(5, 14, '10/03/2024', 687.50, NULL, NULL),
	(5, 15, '10/04/2024', 687.50, NULL, NULL),
	(5, 16, '10/05/2024', 687.50, NULL, NULL),
	(5, 17, '10/06/2024', 687.50, NULL, NULL),
	(5, 18, '10/07/2024', 687.50, NULL, NULL),
	(5, 19, '10/08/2024', 687.50, NULL, NULL),
	(5, 20, '10/09/2024', 687.50, NULL, NULL),
	(5, 21, '10/10/2024', 687.50, NULL, NULL),
	(5, 22, '10/11/2024', 687.50, NULL, NULL),
	(5, 23, '10/12/2024', 687.50, NULL, NULL),
	(5, 24, '10/01/2025', 687.50, NULL, NULL)

-- SELECT * FROM EmprestimoParcela
GO


INSERT INTO Investimento
	(codigoConta, tipo,	aporte,	taxaAdministracao, prazo, grauRisco, rentabilidade,	finalizado)
VALUES
	(1, 'CDB', 10000.00, 0.04, 'medio', 'AA', 1250.00, 1),
	(1, 'acoes', 125000.00, 0.05, 'medio', 'BBB', 0, 0),
	(2, 'acoes', 150000.00, 0.05, 'longo', 'BBB', 0, 0),
	(3, 'CDB', 20000.00, 0.04, 'curto', 'AA', 1500.00, 0),
	(4, 'fundos', 200000.00, 0.05, 'longo', 'BB', 0, 0),
	(3, 'CDB', 15000.00, 0.04, 'medio', 'AA', 1600.00, 0),
	(5, 'TTD', 12000.00, 0.04, 'medio', 'AA-', 1500.00, 0),
	(1, 'acoes', 100000.00, 0.05, 'medio', 'BB', 0, 0)

-- SELECT * FROM Investimento
GO


INSERT INTO ClienteConta
	(codigoCliente,	codigoConta)
VALUES
	(1,1),
	(2,2),
	(2,3),
	(3,4),
	(4,5),
	(1,3),
	(5,7),
	(6,8),
	(7,6),
	(8,4),
	(9,6),
	(10,5)

-- SELECT * FROM ClienteConta
GO
