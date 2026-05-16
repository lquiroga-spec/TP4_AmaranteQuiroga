-- Consulta 13

SELECT med.nombre, COUNT(*) AS veces_recetado
FROM Recetas r
JOIN Medicamentos med ON r.id_medicamento = med.id_medicamento
WHERE r.id_medico = 2
GROUP BY med.nombre
HAVING COUNT(*) > 1;
