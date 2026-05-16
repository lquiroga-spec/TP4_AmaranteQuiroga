-- Consulta 6

SELECT
    nombre,
    calle || ' ' || numero AS direccion
FROM Pacientes
WHERE TRIM(ciudad) ILIKE 'Buenos %Aires%'
   OR TRIM(ciudad) ILIKE 'Buenos Aiers%'
   OR TRIM(ciudad) ILIKE 'Bs%Aires%';
