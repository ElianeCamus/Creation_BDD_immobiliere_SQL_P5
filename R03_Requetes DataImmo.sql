# 3. Proportion des ventes d’appartements par le nombre de pièces.
SELECT  b.Total_piece AS Nombre_de_pieces, 
	ROUND(COUNT(Id_vente) / (SELECT COUNT(Id_vente) 
	FROM vente 
	JOIN bien USING (Id_bien) 
	WHERE Type_local = 'Appartement')*100, 2)
AS "Proportion_ventes_appartements_par_nb_de_pièces_(%)"
FROM bien b
JOIN vente USING (Id_bien)
WHERE b.Type_local = 'Appartement'
GROUP BY b.Total_piece
ORDER BY b.Total_piece;
