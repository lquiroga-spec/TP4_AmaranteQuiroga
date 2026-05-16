-- Consulta 20

SELECT 
    m.nombre AS medico,
    COUNT(*) AS consultas_a_menores
FROM Consultas c
JOIN Medicos m ON c.id_medico = m.id_medico
JOIN Pacientes p ON c.id_paciente = p.id_paciente
WHERE EXTRACT(YEAR FROM AGE(c.fecha, p.fecha_nacimiento)) < 18
GROUP BY m.nombre
ORDER BY consultas_a_menores DESC;
