-- criando database 
CREATE DATABASE reclamacoes_consumidores 
USE reclamacoes_consumidores 

 -- criando tabela de reclamacoes
CREATE TABLE reclamacoes(
 id INT,
 empresa NVARCHAR(1000),
 data_reclamacao NVARCHAR(100),
 localizacao NVARCHAR(1000),
 status_reclamacao NVARCHAR(1000),
 nota NVARCHAR(4000),
 
 ); 


       
BULK INSERT reclamacoes
FROM 'C:\datasets\dados2025.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2, -- Se o arquivo tiver cabeçalho, começar da linha 2
	CODEPAGE = '65001' -- Suporte a UTF-8
);


------Create View -----

CREATE VIEW vw_reclamacoes AS 

SELECT 
    id,
    empresa, 
    data_reclamacao, 
    LEFT(localizacao, CHARINDEX('-', localizacao) - 1) AS Cidade,
    RIGHT(localizacao, LEN(localizacao) - CHARINDEX('-', localizacao)) AS Estado,
    status_reclamacao, 
    REPLACE(nota, ',', '') AS Nota
FROM reclamacoes
WHERE localizacao LIKE '%-%' 
AND TRY_CAST(REPLACE(nota, ',', '') AS INT) IN (1,2,3,4,5);