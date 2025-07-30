# 12. Les 20 communes avec le plus de transactions pour 1000 habitants pour les communes qui dépassent les 10 000 habitants
# Ici 1 vente = 1 bien uniquement, utilisation de MIN pr récupérer la pop unique par commune au lieu de sommer toutes les valeurs de pop
SELECT c.Nom_commune, COUNT(v.Id_vente) AS Nombre_transactions,
ROUND((COUNT(v.Id_vente)/MIN(c.PTOT)*1000),2) AS Transactions_pour_1000_habitants
FROM vente v
JOIN bien b USING (Id_bien)
JOIN commune c USING (id_codedep_codecommune)
WHERE c.PTOT>10000
GROUP BY c.Nom_commune
ORDER BY Transactions_pour_1000_habitants DESC
LIMIT 20;