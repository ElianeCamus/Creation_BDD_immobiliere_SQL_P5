# 7. Taux d’évolution du nombre de ventes entre le 1er et le 2nd trimestre de 2020
WITH Trimestre1 AS (
SELECT COUNT(Id_vente) AS Ventes_T1_2020
FROM vente
WHERE Date_mutation <'2020-04-01'),
Trimestre2 AS (
SELECT COUNT(Id_vente) AS Ventes_T2_2020
FROM vente
WHERE Date_mutation >='2020-04-01')
SELECT ROUND((Ventes_T2_2020 - Ventes_T1_2020)/Ventes_T1_2020 * 100,2) AS Taux_evolution_nombre_ventes_S1_et_S2_2020
FROM Trimestre1,Trimestre2;