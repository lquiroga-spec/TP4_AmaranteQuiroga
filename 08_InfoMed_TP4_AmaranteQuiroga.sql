-- Consulta 8

SELECT 
    ciudad, 
    COUNT(*) AS cantidad_pacientes
FROM Pacientes
GROUP BY ciudad
ORDER BY cantidad_pacientes DESC;
