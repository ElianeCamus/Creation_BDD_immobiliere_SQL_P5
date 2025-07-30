#.11. Les moyennes de valeurs foncières pour le top 3 des communes des départements 6, 13, 33, 59 et 69
# Utiliser With à la place de Create Temporary Table car table tempo se recrée à chaque exécution de requête (error)
WITH Valeurs_Departements AS (
SELECT c.Code_departement AS Departement, c.Nom_commune,
ROUND(AVG(v.Valeur_fonciere),2) AS Moyenne_valeur_foncière,
RANK () 
OVER (PARTITION BY c.Code_departement ORDER BY AVG (v.Valeur_fonciere) DESC) AS Classement_communes
FROM vente v
JOIN bien b USING (Id_bien)
JOIN commune c USING (id_codedep_codecommune)
WHERE c.Code_departement IN ('6', '13', '33', '59', '69')
GROUP BY c.Code_departement, c.Nom_commune
ORDER BY Moyenne_valeur_foncière DESC)
SELECT * FROM Valeurs_Departements
WHERE Classement_communes <= '3';