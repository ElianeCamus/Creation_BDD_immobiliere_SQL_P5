# 5. Prix moyen du mètre carré d’une maison en Île-de-France
SELECT r.Nom_region, ROUND( AVG(v.Valeur_fonciere/b.Surface_carrez)) AS Prix_au_M2
FROM bien b
JOIN vente v USING (Id_bien)
JOIN commune USING (id_codedep_codecommune)
JOIN region r USING (Code_region)
WHERE Type_local = 'Maison'
AND r.Nom_region = 'Ile-de-France';