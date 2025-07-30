# 9. Liste des communes ayant eu au moins 50 ventes au 1er trimestre
SELECT c.Nom_commune, COUNT(Id_vente) AS Nombre_ventes_appartements_T1_2020
FROM vente v
JOIN bien b USING (Id_bien)
JOIN commune c USING (id_codedep_codecommune)
WHERE v.Date_mutation < '2020-04-01'
GROUP BY c.Nom_commune
HAVING Nombre_ventes_appartements_T1_2020 >=50
ORDER BY c.Nom_commune ASC;