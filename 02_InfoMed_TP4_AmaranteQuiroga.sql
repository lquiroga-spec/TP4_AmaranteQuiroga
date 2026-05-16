-- Consulta 2

CREATE VIEW vista_pacientes_edad AS
SELECT 
    *, 
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, fecha_nacimiento)) AS edad
FROM Pacientes;
SELECT nombre, fecha_nacimiento, edad FROM vista_pacientes_edad;
