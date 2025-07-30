# 6. Liste des 10 appartements les plus chers avec la région et le nombre de mètres carrés
SELECT b.Id_bien, 
	r.Nom_region, 
	ROUND(b.Surface_carrez) AS Surface_M2, 
	ROUND(v.Valeur_fonciere) AS Valeur_fonciere
FROM bien b
JOIN vente v USING (Id_bien)
JOIN commune c USING (id_codedep_codecommune)
JOIN region r USING (Code_region)
WHERE Type_local = 'Appartement'
ORDER BY v.Valeur_fonciere DESC
LIMIT 10;