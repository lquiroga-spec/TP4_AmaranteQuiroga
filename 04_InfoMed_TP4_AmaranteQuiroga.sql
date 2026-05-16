-- Consulta 4

SELECT 
    nombre, 
    calle, 
    numero, 
    ciudad 
FROM Pacientes 
WHERE nombre = 'Luciana Gómez';
UPDATE Pacientes
SET calle = 'Calle Corrientes',
    numero = '500'
WHERE nombre = 'Luciana Gómez';
SELECT 
    nombre, 
    calle, 
    numero, 
    ciudad 
FROM Pacientes 
WHERE nombre = 'Luciana Gómez';
