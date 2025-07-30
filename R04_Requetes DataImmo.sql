# 4. Liste des 10 départements où le prix du mètre carré est le plus élevé
SELECT c.Code_departement AS Numero_departement, 
	c.Nom_departement,
	ROUND( AVG(v.Valeur_fonciere/b.Surface_carrez)) AS Prix_au_M2
FROM vente v
JOIN bien b USING (Id_bien)
JOIN commune c USING (id_codedep_codecommune)
GROUP BY c.Code_departement,c.Nom_departement
ORDER BY Prix_au_M2 DESC
LIMIT 10;
