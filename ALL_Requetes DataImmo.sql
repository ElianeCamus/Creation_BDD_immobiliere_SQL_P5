# 1. Nombre total d’appartements vendus au 1er semestre 2020.
SELECT COUNT(Id_vente) AS Nb_appartements_vendus_S1_2020
FROM vente
JOIN bien USING (Id_bien)
WHERE Type_local = 'Appartement'
AND Date_mutation BETWEEN '2020-01-01' AND '2020-06-30';


# 2. Nombre de ventes d’appartement par région pour le 1er semestre 2020.
SELECT r.Nom_region AS Région, COUNT(v.Id_vente) AS Nb_ventes_appartements_S1_2020
FROM vente v
JOIN bien USING (Id_bien)
JOIN commune USING (id_codedep_codecommune)
JOIN region r USING (Code_region)
WHERE Type_local = 'Appartement'
AND Date_mutation BETWEEN '2020-01-01' AND '2020-06-30'
GROUP BY r.Nom_region
ORDER BY Nb_ventes_appartements_S1_2020 DESC;


# 3. Proportion des ventes d’appartements par le nombre de pièces.
SELECT  b.Total_piece, 
ROUND(COUNT(Id_vente)*100 / (SELECT COUNT(Id_vente) FROM vente JOIN bien USING (Id_bien) WHERE Type_local = 'Appartement'), 2)
AS "Proportion_ventes_appartements_par_nb_de_pièces"
FROM bien b
JOIN vente  USING (Id_bien)
WHERE b.Type_local = 'Appartement'
GROUP BY b.Total_piece
ORDER BY b.Total_piece;


# 4. Liste des 10 départements où le prix du mètre carré est le plus élevé
SELECT c.Code_departement AS No_departement, ROUND( AVG(v.Valeur_fonciere/b.Surface_carrez),2) AS Prix_au_m2
FROM vente v
JOIN bien b USING (Id_bien)
JOIN commune c USING (id_codedep_codecommune)
GROUP BY c.Code_departement
ORDER BY Prix_au_m2 DESC
LIMIT 10;


# 5. Prix moyen du mètre carré d’une maison en Île-de-France
SELECT r.Nom_region AS Région, ROUND( AVG(v.Valeur_fonciere/b.Surface_carrez),2) AS Prix_au_m2
FROM bien b
JOIN vente v USING (Id_bien)
JOIN commune USING (id_codedep_codecommune)
JOIN region r USING (Code_region)
WHERE Type_local = 'Maison'
AND r.Nom_region = 'Ile-de-France';


# 6. Liste des 10 appartements les plus chers avec la région et le nombre de mètres carrés
SELECT b.Id_bien, b.Surface_carrez AS Surface_M2, ROUND(v.Valeur_fonciere), r.Nom_region AS Région
FROM bien b
JOIN vente v USING (Id_bien)
JOIN commune c USING (id_codedep_codecommune)
JOIN region r USING (Code_region)
WHERE Type_local = 'Appartement'
ORDER BY v.Valeur_fonciere DESC
LIMIT 10;


# 7. Taux d’évolution du nombre de ventes entre le 1er et le 2nd trimestre de 2020
WITH Trimestre1 AS (
SELECT COUNT(Id_vente) AS Ventes_T1
FROM vente
WHERE Date_mutation <'2020-04-01'),
Trimestre2 AS (
SELECT COUNT(Id_vente) AS Ventes_T2
FROM vente
WHERE Date_mutation >='2020-04-01')
SELECT (Ventes_T2 - Ventes_T1)/Ventes_T1 * 100 AS Taux_evol_nb_ventes_S1_S2_2020
FROM Trimestre1,Trimestre2;


# 8. Le classement des régions par rapport au prix au mètre carré des appartement de plus de 4 pièces
SELECT r.Nom_region AS Région, ROUND( AVG(v.Valeur_fonciere/b.Surface_carrez),2) AS Prix_M2
FROM vente v
JOIN bien b USING (Id_bien)
JOIN commune c USING (id_codedep_codecommune)
JOIN region r USING (Code_region)
WHERE b.Type_local = 'Appartement'
AND b.Total_piece >4
GROUP BY Région
ORDER BY Prix_M2 DESC;


# 9. Liste des communes ayant eu au moins 50 ventes au 1er trimestre
SELECT c.Nom_commune AS Communes, COUNT(Id_vente) AS Nb_ventes_appartements_T1
FROM vente v
JOIN bien b USING (Id_bien)
JOIN commune c USING (id_codedep_codecommune)
WHERE v.Date_mutation < '2020-04-01'
GROUP BY c.Nom_commune
HAVING Nb_ventes_appartements_T1 >=50
ORDER BY Communes ASC;


# 10. Différence en pourcentage du prix au mètre carré entre un appartement de 2 pièces et un appartement de 3 pièces
WITH 2pieces AS (
SELECT b.Type_local, b.Total_piece, ROUND (AVG(v.Valeur_fonciere/b.Surface_carrez),2) AS Prix_m2_2p
FROM vente v
JOIN bien b USING (Id_bien)
WHERE b.Type_local= 'Appartement'
AND b.Total_piece= 2),
3pieces AS (
SELECT b.Type_local, b.Total_piece, ROUND (AVG(v.Valeur_fonciere/b.Surface_carrez),2) AS Prix_m2_3p
FROM vente v
JOIN bien b USING (Id_bien)
WHERE b.Type_local= 'Appartement'
AND b.Total_piece= 3)
SELECT ROUND (((Prix_m2_3p - Prix_m2_2p)/Prix_m2_2p)*100, 2) AS Différence_pourcentage_M2_entre_2p_et_3p
FROM 2pieces,3pieces;


#.11. Les moyennes de valeurs foncières pour le top 3 des communes des départements 6, 13, 33, 59 et 69
# Utiliser WIth à la place de Create Temporary Table car table tempo se recrée à chaque exécution de requête (error)
WITH Departements AS (
SELECT c.Code_departement AS Département, c.Nom_commune AS Commune,
ROUND(AVG(v.Valeur_fonciere),2) AS Moyenne_valeur_foncière,
RANK () 
OVER (PARTITION BY c.Code_departement ORDER BY AVG (v.Valeur_fonciere) DESC) AS Classement_communes
FROM vente v
JOIN bien b USING (Id_bien)
JOIN commune c USING (id_codedep_codecommune)
WHERE c.Code_departement IN ('6', '13', '33', '59', '69')
GROUP BY c.Code_departement, c.Nom_commune
ORDER BY Moyenne_valeur_foncière DESC)
SELECT * FROM Departements
WHERE Classement_communes <= '3';


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