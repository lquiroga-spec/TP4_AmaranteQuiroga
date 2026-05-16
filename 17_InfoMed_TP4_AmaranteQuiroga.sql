-- Consulta 17

SELECT 
    m.nombre AS medico,
    p.nombre AS paciente,
    COUNT(*) AS total_consultas
FROM Consultas c
JOIN Medicos m ON c.id_medico = m.id_medico
JOIN Pacientes p ON c.id_paciente = p.id_paciente
GROUP BY m.nombre, p.nombre
ORDER BY m.nombre ASC, p.nombre ASC;
