-- Consulta 10

SELECT 
    m.id_medico,
    m.nombre AS medico, 
    COUNT(r.id_receta) AS total_recetas
FROM Medicos m
LEFT JOIN Recetas r ON m.id_medico = r.id_medico
GROUP BY m.id_medico, m.nombre
ORDER BY total_recetas DESC;
