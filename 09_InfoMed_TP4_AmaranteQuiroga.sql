-- Consulta 9

SELECT 
    p.ciudad, 
    s.descripcion AS sexo, 
    COUNT(*) AS cantidad
FROM Pacientes p
INNER JOIN SexoBiologico s ON p.id_sexo = s.id_sexo
GROUP BY p.ciudad, s.descripcion
ORDER BY p.ciudad ASC, cantidad DESC;
