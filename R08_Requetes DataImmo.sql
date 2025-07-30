# 8. Le classement des régions par rapport au prix au mètre carré des appartement de plus de 4 pièces
SELECT r.Nom_region, 
	ROUND( AVG(v.Valeur_fonciere/b.Surface_carrez)) AS Prix_au_M2
FROM vente v
JOIN bien b USING (Id_bien)
JOIN commune c USING (id_codedep_codecommune)
JOIN region r USING (Code_region)
WHERE b.Type_local = 'Appartement'
AND b.Total_piece >4
GROUP BY r.Nom_region
ORDER BY Prix_au_M2 DESC;