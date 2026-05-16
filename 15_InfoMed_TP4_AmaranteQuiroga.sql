-- Consulta 15

SELECT med.nombre, COUNT(*) AS total_recetas
FROM Recetas r
JOIN Medicamentos med ON r.id_medicamento = med.id_medicamento
GROUP BY med.nombre
ORDER BY total_recetas DESC
LIMIT 1;
