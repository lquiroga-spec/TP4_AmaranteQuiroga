-- Consulta 7

-- 1. Unificamos Buenos Aires (Cubre: "Bs Aires", "Buenos Aiers", "  Buenos Aires", etc.)
UPDATE Pacientes
SET ciudad = 'Buenos Aires'
WHERE TRIM(ciudad) ILIKE 'B% Aires' 
   OR TRIM(ciudad) ILIKE 'Buenos %Aiers%';

-- 2. Unificamos Córdoba (Cubre: "Córodba", "Cordoba" y tildes)
UPDATE Pacientes
SET ciudad = 'Córdoba'
WHERE TRIM(ciudad) ILIKE 'C%r%ba';

-- 3. Unificamos Mendoza (Cubre: "Mendzoa")
UPDATE Pacientes
SET ciudad = 'Mendoza'
WHERE TRIM(ciudad) ILIKE 'Mend%a';

-- 4. Unificamos Rosario (Cubre: "rosario")
UPDATE Pacientes
SET ciudad = 'Rosario'
WHERE TRIM(ciudad) ILIKE 'Rosario';

-- 5. Print de verificación (Esto es lo que tenés que ver en el Fiddle)
SELECT DISTINCT ciudad 
FROM Pacientes 
ORDER BY ciudad ASC;
