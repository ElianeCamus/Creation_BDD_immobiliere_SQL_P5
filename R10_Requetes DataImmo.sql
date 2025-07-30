# 10. Différence en pourcentage du prix au mètre carré entre un appartement de 2 pièces et un appartement de 3 pièces
WITH 2pieces AS (
SELECT b.Type_local, b.Total_piece, ROUND (AVG(v.Valeur_fonciere/b.Surface_carrez),2) AS Prix_M2_2p
FROM vente v
JOIN bien b USING (Id_bien)
WHERE b.Type_local= 'Appartement' AND b.Total_piece= 2),
3pieces AS (
SELECT b.Type_local, b.Total_piece, ROUND (AVG(v.Valeur_fonciere/b.Surface_carrez),2) AS Prix_M2_3p
FROM vente v
JOIN bien b USING (Id_bien)
WHERE b.Type_local= 'Appartement' AND b.Total_piece= 3)
SELECT ROUND (((Prix_M2_3p - Prix_M2_2p)/Prix_M2_2p)*100, 2) AS Différence_pourcentage_prix_au_M2_entre_2_pieces_et_3_pieces
FROM 2pieces,3pieces;
