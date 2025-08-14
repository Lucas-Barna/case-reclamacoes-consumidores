
-- QTD reclamações por região --

SELECT
  r.Estado AS 'Região',
  COUNT(r.id)AS 'QTD_Reclamacoes'
FROM 
	vw_reclamacoes r
GROUP BY
r.Estado
ORDER BY
	QTD_Reclamacoes DESC



-- QTD	Reclamações mensal --

SELECT 
    MONTH(CONVERT(date, r.data_reclamacao)) AS Mes,
	YEAR(CONVERT(date, r.data_reclamacao)) AS Ano,
    COUNT(r.id) AS QTD_Reclamacoes
FROM 
    vw_reclamacoes r
GROUP BY 
    MONTH(CONVERT(date, r.data_reclamacao)),
	YEAR(CONVERT(date, r.data_reclamacao))

ORDER BY 
    Ano,Mes 
	


--- Média de notas e QTD reclamações são maiores que 100 por Empresas--

SELECT 
  r.empresa AS 'Empresas',
  COUNT(r.id)AS 'QTD_Reclamacoes',
  FORMAT(AVG(CAST(r.[Nota] AS DECIMAL(10,2))), 'N2') AS 'Media_Nota'
FROM 
    vw_reclamacoes r

GROUP BY 
    r.empresa
HAVING 
    COUNT(r.id) > 100
ORDER BY 
    QTD_Reclamacoes DESC


--- Média de notas, QTD de reclamações resolvidas, não resolvidas, total, porcentagem,  por Empresas --
 
 SELECT 
  r.empresa AS 'Empresas',
 --Sub Resolvidas--
 
 (SELECT COUNT(r1.id) 
  FROM vw_reclamacoes r1
  WHERE r1.empresa= r.empresa and r1.status_reclamacao = 'Resolvido'
 ) AS 'Reclamacoes_Resolvidas',
 
 --Sub Não Resolvidas--

 (SELECT COUNT(r2.id) 
  FROM vw_reclamacoes r2
  WHERE r2.empresa=r.empresa and r2.status_reclamacao = 'Não Resolvido'
 ) AS 'Reclamacoes_Nao_Resolvidas',

 COUNT(r.id)AS 'QTD_Reclamacoes',
 
 -- Proporção de resolvidas
FORMAT(
 CAST(
    (SELECT COUNT(r1.id)  
     FROM vw_reclamacoes r1
     WHERE r1.empresa = r.empresa AND r1.status_reclamacao = 'Resolvido'
    ) AS FLOAT
  ) / COUNT(r.id),'P2') AS '%_Resolucao',


  FORMAT(AVG(CAST(r.[Nota] AS DECIMAL(10,2))), 'N2') AS 'Media_Nota'
FROM 
    vw_reclamacoes r

GROUP BY 
    r.empresa
ORDER BY 
CAST(
    (SELECT COUNT(r1.id)  
     FROM vw_reclamacoes r1
     WHERE r1.empresa = r.empresa AND r1.status_reclamacao = 'Resolvido'
    ) AS FLOAT
  ) / COUNT(r.id)  DESC


