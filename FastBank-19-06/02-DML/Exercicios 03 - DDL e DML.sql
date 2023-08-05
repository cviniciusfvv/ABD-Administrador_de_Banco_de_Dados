/*-----------------------------
Banco: Playlist
Autor: Ralfe
�ltima altera��o: 29/03/2023
Descri��o: Exerc�cios DDL e DML
-----------------------------*/

-- Crie um banco de dados nomeado Playlist

-- Estabele�a a conex�o com o banco

-- Crie uma tabela chamada Musica com os seguintes atributos:
/*
	codigo INT
	titulo VARCHAR(50)
	artista VARCHAR(50)
	nacionalidade VARCHAR(50)
	album VARCHAR(50)
	anoLancamento INT
	duracao TIME
	streaming BIT

	Obs.: O atributo codigo ser� a chave prim�ria e incrementada pelo banco
*/


-- Insira as m�sicas (registros) abaixo na tabela Musica:
/*
----------------------------------------------------------------------------------------------------------------------
T�tulo                    Artista         Nacionalidade    Album                 Ano lan�amento   Dura��o    Streaming
----------------------------------------------------------------------------------------------------------------------
Black Sabbath             Black Sabbath   Inglaterra       Black Sabbath         1970             00:06:17   1
Foxey Lady                Jimi Hendrix    Estados Unidos   Are You Experienced   1967             00:03:19   1
Working Man               Rush            Canad�           Rush                  1974             00:07:09   1
Communication Breakdown   Led Zeppelin    Inglaterra       Led Zeppelin          1969             00:02:30   0
Hey Joe                   Jimi Hendrix    Estados Unidos   Are You Experienced   1968             00:03:30   1
The Trees                 Rush            Canad�           Hemispheres           1978             00:04:42   1
War Pigs                  Black Sabbath   Inglaterra       Paranoid              1970             00:07:54   0
Immigrant Song            Led Zeppelin    Inglaterra       Led Zeppelin III      1970             00:02:26   1
Sweet Leaf                Black Sabbath   Inglaterra       Master Of Reality     1971             00:05:03   1
Anthem                    Rush            Canad�           Fly By Nigth          1975             00:04:21   0
Litle Wing                Jimi Hendrix    Estados Unidos   Axis: Bold As Love    1967             00:02:25   1
Whole Lotta Love          Led Zeppelin    Inglaterra       Led Zeppelin II       1969             00:05:34   1
----------------------------------------------------------------------------------------------------------------------
*/

-- Crie as instru��es SQL para as seguintes manipula��es dos dados armazenados na tabela Musica:

-- 01. Consulte todas as informa��es de todas as m�sicas
-- 02. Consulte o titulo, o artista e o album de todas as musicas
-- 03. Consulte as m�sicas do artista Black Sabbath
-- 04. Consulte as m�sicas (apresentando somente o titulo) de artistas da Inglaterra
-- 05. Consulte as m�sicas (apresentando o nome do album e o ano de lan�amento) de albuns anteriores a 1970
-- 06. Consulte as m�sicas (apresentando o nome do artista e o titulo da m�sica) com mais de 5 minutos
-- 07. Consulte as m�sicas que n�o est�o disponiveis nas plataformas de streaming
-- 08. Altere o ano de lan�amento do album da musica Hey Joe para 1967
-- 09. Altere o titulo da m�sica Sweet Leaf para Sweet Love Leaf
-- 10. Altere o titulo da m�sica Foxey Lady para Foxey Love Lady e a disponibilidade em streaming para negativo
-- 11. Altere a nacionalidade das m�sicas do artista Led Zeppelin para Reino Unido
-- 12. Consulte a(s) m�sica(s) que o titulo comece com The
-- 13. Consulte a(s) musica(s) que o titulo termine com Breakdown
-- 14. Consulte a(s) musica(s) que o titulo contenha a palavra Love no meio
-- 15. Consulte as m�sicas (apresentando o nome do album e se est� disponivel em streaming) do artista Black Sabbath lan�adas em 1970 
-- 16. Consulte as m�sicas de albuns lan�ados entre 1970 e 1975
-- 17. Consulte as 5 primeiras m�sicas da playlist
-- 18. Consulte o titulo, artista e anoLancamento das m�sicas do artista Rush nomeando as colunas respectivamente como M�sica, Banda e Ano Lan�amento
-- 19. Consulte as diferentes nacionalidades das m�sicas (sem repeti-las)
-- 20. Consulte todas as m�sicas em ordem alfab�ticas por titulo
-- 21. Consulte as m�sicas do artista Rush em ordem de lan�amento
-- 22. Consulte o titulo e dura��o de todas as m�sicas em ordem decrescente de dura��o
-- 23. Consulte a m�sica mais longa
-- 24. Consulte a m�sica mais curta
-- 25. Consulte quantas m�sicas do Jimi Hendrix existem na playlist