/*------------------------------------------------
Banco: Livraria
Autor: Ralfe
Última alteração: 01/06/2023 - 19:00 - Ralfe
Descrição: Stored Procedure com Tratamento de erros
-------------------------------------------------*/
/*
Desenvolva uma Stored Procedure para inserção de (um) livro (stpInsercaoLivro)
a partir das especificações abaixo:

	Escolha um livro de sua preferência e utilize seus dados para a inclusão 
	(caso falte alguma informação coloque dados ficticios). Todos os atributos devem ser preenchidos.

	Cinco tabelas serão afetadas. Crie "Tipos de Tabelas Definidas pelo Usuario" para cada uma delas.

	Esses tipos serão utilizados para declarar os parâmetros que a Stored Procedure irá receber 
	e para as "Variáveis de Tabelas" que serão passadas por parâmetros na execução da SP.

	Na SP, depois de recuperar os parâmetros em variáveis, monte as inserções respeitando as restrições
	do modelo (relacionamentos) na seguinte ordem: Produto, Livro, Imagem, Autor e AutorProduto
	(entenda os motivos dessa sequencia).

	Esse é um bom momento para testar e verificar se todas as inserções serão realizadas corretamente.
	Os dados podem ser atribuidos diteramente nas variáveis e o teste pode ser somente do script.
	(sem criar a SP)

	Feito os primeiros testes, conclua a estrutura da SP; crie a SP e teste, agora executando a SP
	passando os dados (em variáveis de tabela) por parâmetro. Teste.

	Implemente o controle de transação e o try..catch.

	Gere um erro (reconhecível pelo mecanismo do SQL Server), por exemplo, comentando uma linha de 
	instrução que ocasione um erro. Verifique o código do erro e implemente seu tratamento específico
	(identificado por uma mensagem personalizada/direcionada)

	Implemente uma verificação referente as regras do modelo, por exemplo, inserindo um número negativo 
	onde não faça sentido ou verificando se foi informado algum valor diferente de 0 ou 1 em um atributo BIT. 
	Gere um erro (RAISERROR) e implemente seu tratamento específico
	(identificado por uma mensagem personalizada/direcionada)

	Implemente um último tratamento para eventuais erros imprevistos coletando informações sobre ele.

	Todas as mensagens de erro devem gerar um único texto.

	Nesse ponto, teste os erros e suas respectivas mensagens apresentando o texto gerado na guia Mensagem
	(PRINT ou RAISERROR)

	Crie um objeto SEQUENCE nomeado CodigoLogErro do tipo INT começando de 1 incrementando de 1 em 1.

	Crie uma tabela nomeada LogErros com os atributos: 
	-> codigo INT incrementado pelo objeto SEQUENCE CodigoLogErro (Chave primária)
	-> dataHora DATETIME pegando a data e hora do sistema
	-> detalhe VARCHAR(MAX)

	Implemente a inserção das mensagens de erros geradas na SP nessa tabela.

	Realize os últimos testes verificando se todas inserções serão realizadas corretamente em casos
	de execução com sucesso e teste as possibilidades de tratamento de erros verificando se os 
	logs serão armazenados corretamente.
*/
