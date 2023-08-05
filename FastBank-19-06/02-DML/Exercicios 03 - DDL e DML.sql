/*-----------------------------
Banco: Playlist
Autor: Ralfe
Última alteração: 29/03/2023
Descrição: Exercícios DDL e DML
-----------------------------*/

-- Crie um banco de dados nomeado Playlist

-- Estabeleça a conexão com o banco

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

	Obs.: O atributo codigo será a chave primária e incrementada pelo banco
*/


-- Insira as músicas (registros) abaixo na tabela Musica:
/*
----------------------------------------------------------------------------------------------------------------------
Título                    Artista         Nacionalidade    Album                 Ano lançamento   Duração    Streaming
----------------------------------------------------------------------------------------------------------------------
Black Sabbath             Black Sabbath   Inglaterra       Black Sabbath         1970             00:06:17   1
Foxey Lady                Jimi Hendrix    Estados Unidos   Are You Experienced   1967             00:03:19   1
Working Man               Rush            Canadá           Rush                  1974             00:07:09   1
Communication Breakdown   Led Zeppelin    Inglaterra       Led Zeppelin          1969             00:02:30   0
Hey Joe                   Jimi Hendrix    Estados Unidos   Are You Experienced   1968             00:03:30   1
The Trees                 Rush            Canadá           Hemispheres           1978             00:04:42   1
War Pigs                  Black Sabbath   Inglaterra       Paranoid              1970             00:07:54   0
Immigrant Song            Led Zeppelin    Inglaterra       Led Zeppelin III      1970             00:02:26   1
Sweet Leaf                Black Sabbath   Inglaterra       Master Of Reality     1971             00:05:03   1
Anthem                    Rush            Canadá           Fly By Nigth          1975             00:04:21   0
Litle Wing                Jimi Hendrix    Estados Unidos   Axis: Bold As Love    1967             00:02:25   1
Whole Lotta Love          Led Zeppelin    Inglaterra       Led Zeppelin II       1969             00:05:34   1
----------------------------------------------------------------------------------------------------------------------
*/

-- Crie as instruções SQL para as seguintes manipulações dos dados armazenados na tabela Musica:

-- 01. Consulte todas as informações de todas as músicas
-- 02. Consulte o titulo, o artista e o album de todas as musicas
-- 03. Consulte as músicas do artista Black Sabbath
-- 04. Consulte as músicas (apresentando somente o titulo) de artistas da Inglaterra
-- 05. Consulte as músicas (apresentando o nome do album e o ano de lançamento) de albuns anteriores a 1970
-- 06. Consulte as músicas (apresentando o nome do artista e o titulo da música) com mais de 5 minutos
-- 07. Consulte as músicas que não estão disponiveis nas plataformas de streaming
-- 08. Altere o ano de lançamento do album da musica Hey Joe para 1967
-- 09. Altere o titulo da música Sweet Leaf para Sweet Love Leaf
-- 10. Altere o titulo da música Foxey Lady para Foxey Love Lady e a disponibilidade em streaming para negativo
-- 11. Altere a nacionalidade das músicas do artista Led Zeppelin para Reino Unido
-- 12. Consulte a(s) música(s) que o titulo comece com The
-- 13. Consulte a(s) musica(s) que o titulo termine com Breakdown
-- 14. Consulte a(s) musica(s) que o titulo contenha a palavra Love no meio
-- 15. Consulte as músicas (apresentando o nome do album e se está disponivel em streaming) do artista Black Sabbath lançadas em 1970 
-- 16. Consulte as músicas de albuns lançados entre 1970 e 1975
-- 17. Consulte as 5 primeiras músicas da playlist
-- 18. Consulte o titulo, artista e anoLancamento das músicas do artista Rush nomeando as colunas respectivamente como Música, Banda e Ano Lançamento
-- 19. Consulte as diferentes nacionalidades das músicas (sem repeti-las)
-- 20. Consulte todas as músicas em ordem alfabéticas por titulo
-- 21. Consulte as músicas do artista Rush em ordem de lançamento
-- 22. Consulte o titulo e duração de todas as músicas em ordem decrescente de duração
-- 23. Consulte a música mais longa
-- 24. Consulte a música mais curta
-- 25. Consulte quantas músicas do Jimi Hendrix existem na playlist