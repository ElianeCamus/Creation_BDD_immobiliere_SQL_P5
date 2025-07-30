# 2. Nombre de ventes d’appartement par région pour le 1er semestre 2020.
SELECT r.Nom_region AS Nom_de_region, COUNT(v.Id_vente) AS Nombre_ventes_appartements_S1_2020
FROM vente v
JOIN bien USING (Id_bien)
JOIN commune USING (id_codedep_codecommune)
JOIN region r USING (Code_region)
WHERE Type_local = 'Appartement'
AND Date_mutation BETWEEN '2020-01-01' AND '2020-06-30'
GROUP BY Nom_de_region
ORDER BY Nombre_ventes_appartements_S1_2020 DESC;
