# 1. Nombre total d’appartements vendus au 1er semestre 2020.
SELECT COUNT(Id_vente) AS Nombre_appartements_vendus_S1_2020
FROM vente
JOIN bien USING (Id_bien)
WHERE Type_local = 'Appartement'
AND Date_mutation BETWEEN '2020-01-01' AND '2020-06-30';
