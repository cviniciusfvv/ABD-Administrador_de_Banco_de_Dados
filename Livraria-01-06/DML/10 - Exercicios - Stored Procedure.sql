/*------------------------------------------------
Banco: Livraria
Autor: Ralfe
�ltima altera��o: 01/06/2023 - 19:00 - Ralfe
Descri��o: Stored Procedure com Tratamento de erros
-------------------------------------------------*/
/*
Desenvolva uma Stored Procedure para inser��o de (um) livro (stpInsercaoLivro)
a partir das especifica��es abaixo:

	Escolha um livro de sua prefer�ncia e utilize seus dados para a inclus�o 
	(caso falte alguma informa��o coloque dados ficticios). Todos os atributos devem ser preenchidos.

	Cinco tabelas ser�o afetadas. Crie "Tipos de Tabelas Definidas pelo Usuario" para cada uma delas.

	Esses tipos ser�o utilizados para declarar os par�metros que a Stored Procedure ir� receber 
	e para as "Vari�veis de Tabelas" que ser�o passadas por par�metros na execu��o da SP.

	Na SP, depois de recuperar os par�metros em vari�veis, monte as inser��es respeitando as restri��es
	do modelo (relacionamentos) na seguinte ordem: Produto, Livro, Imagem, Autor e AutorProduto
	(entenda os motivos dessa sequencia).

	Esse � um bom momento para testar e verificar se todas as inser��es ser�o realizadas corretamente.
	Os dados podem ser atribuidos diteramente nas vari�veis e o teste pode ser somente do script.
	(sem criar a SP)

	Feito os primeiros testes, conclua a estrutura da SP; crie a SP e teste, agora executando a SP
	passando os dados (em vari�veis de tabela) por par�metro. Teste.

	Implemente o controle de transa��o e o try..catch.

	Gere um erro (reconhec�vel pelo mecanismo do SQL Server), por exemplo, comentando uma linha de 
	instru��o que ocasione um erro. Verifique o c�digo do erro e implemente seu tratamento espec�fico
	(identificado por uma mensagem personalizada/direcionada)

	Implemente uma verifica��o referente as regras do modelo, por exemplo, inserindo um n�mero negativo 
	onde n�o fa�a sentido ou verificando se foi informado algum valor diferente de 0 ou 1 em um atributo BIT. 
	Gere um erro (RAISERROR) e implemente seu tratamento espec�fico
	(identificado por uma mensagem personalizada/direcionada)

	Implemente um �ltimo tratamento para eventuais erros imprevistos coletando informa��es sobre ele.

	Todas as mensagens de erro devem gerar um �nico texto.

	Nesse ponto, teste os erros e suas respectivas mensagens apresentando o texto gerado na guia Mensagem
	(PRINT ou RAISERROR)

	Crie um objeto SEQUENCE nomeado CodigoLogErro do tipo INT come�ando de 1 incrementando de 1 em 1.

	Crie uma tabela nomeada LogErros com os atributos: 
	-> codigo INT incrementado pelo objeto SEQUENCE CodigoLogErro (Chave prim�ria)
	-> dataHora DATETIME pegando a data e hora do sistema
	-> detalhe VARCHAR(MAX)

	Implemente a inser��o das mensagens de erros geradas na SP nessa tabela.

	Realize os �ltimos testes verificando se todas inser��es ser�o realizadas corretamente em casos
	de execu��o com sucesso e teste as possibilidades de tratamento de erros verificando se os 
	logs ser�o armazenados corretamente.
*/
