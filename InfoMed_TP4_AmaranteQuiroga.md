# TP4 - Bases de Datos y Manejo de Versiones
<img width="280" height="280" alt="image" src="https://github.com/user-attachments/assets/7ef49b87-5f7e-46ae-a03b-5c35f08dac39" />


**Materia:** Informática Médica (16.22) | **Instituto:** ITBA | **Año:** 2026

**Integrantes:** Morena Amarante - Lucia Quiroga

---

## PARTE 1: Bases de Datos

### Consigna 1 — Tipo de base de datos

El sistema propuesto para el centro de salud se clasifica, según su estructura, como una **Base de Datos Relacional**. Esta arquitectura se fundamenta en la organización de la información a través de tablas conectadas entre sí mediante el uso de claves primarias y foráneas. Este diseño permite representar de manera eficiente las entidades del mundo real mencionadas en el enunciado, como pacientes, médicos, consultas y recetas, garantizando que la relación entre ellas (por ejemplo, qué médico emitió qué receta a qué paciente) sea consistente y sin duplicidad de datos.
Desde el punto de vista de su propósito, se define como una base de datos Transaccional u Operacional (OLTP - Online Transaction Processing). Su objetivo principal es actuar como el soporte tecnológico de las operaciones cotidianas de la clínica en tiempo real. Al buscar el reemplazo de los registros físicos por una solución digital, el sistema debe gestionar una escritura intensiva de datos (altas de pacientes, registros de visitas y emisión de prescripciones) asegurando un acceso rápido y una alta integridad referencial para el seguimiento clínico y las auditorías posteriores.
Finalmente, según su dominio de aplicación, también puede catalogarse como una base de datos clínica o médica. Esta clasificación es relevante porque implica que el sistema no solo almacena datos administrativos, sino que está diseñado para el análisis epidemiológico y el seguimiento de condiciones de salud. Al estar normalizada, la base de datos facilita la obtención de estadísticas demográficas y de especialidades, integrándose a futuro con otros módulos complejos como el historial clínico digital o la gestión de turnos.


---

### Consigna 2 — Diagrama Entidad-Relación (Notación de Chen)

**Diseño Conceptual: Modelo Entidad-Relación - Notación de Chen.**

Para el diseño del sistema del Centro Médico, se ha optado por un modelo centrado en el evento clínico. A diferencia de un registro de documentos lineal, este esquema propone a la Consulta como entidad integradora. Este enfoque permite que el sistema no solo registre recetas, sino que funcione como una base para la historia clínica, donde los médicos y pacientes interactúan en encuentros formales que pueden, o no, derivar en la emisión de prescripciones médicas.
En la estructura diseñada, la entidad Consulta actúa como el núcleo del diagrama. Se establece una relación de participación total con las entidades Médico y Paciente, garantizando que no existan registros de atención sin sus protagonistas esenciales. Por otro lado, la Receta se define como una entidad dependiente de la consulta (participación total por el lado de la receta); esto refleja la normativa legal y médica donde toda prescripción debe estar respaldada por un acto médico previo.
Finalmente, el modelo incorpora la normalización de datos desde su concepción conceptual. Los atributos de Dirección y Tratamiento se han modelado como atributos compuestos para permitir un desglose atómico de la información (calle, ciudad, dosis, tiempo), facilitando así los análisis estadísticos y el seguimiento epidemiológico solicitados. La entidad Enfermedad se mantiene independiente, permitiendo que el catálogo de diagnósticos sea reutilizable en múltiples consultas y facilitando la generación de reportes sobre salud pública.

![Diagrama Chen](Imagenes%20parte%201/TP4_InfoMed_Chen.drawio.png)

---

### Consigna 3 — Modelo Relacional (Notación Crow's Foot)

![Diagrama Crow's Foot](Imagenes%20parte%201/TP4_InfoMed_Chen-Crow's%20Foot.drawio.png)

---

### Consigna 4 — Formas Normales

**Caso 1: Violación de la Primera Forma Normal (1FN)**
En este escenario se incumple el principio de atomicidad de los datos, ya que el atributo "Teléfonos" contiene múltiples valores (grupos repetidos) dentro de una misma celda para la paciente Ana. Para normalizar, cada intersección de fila y columna debe contener un único valor indivisible. La solución técnica consiste en desglosar los números de contacto en filas independientes o, idealmente, crear una tabla secundaria de teléfonos vinculada al ID del paciente, eliminando así la existencia de atributos no atómicos.

**Caso 2: Violación de la Tercera Forma Normal (3FN)**
Aquí se identifica una dependencia transitiva, donde el atributo "CódigoPostal" no depende directamente de la clave primaria (PacienteID), sino de otro atributo no clave como es la "Ciudad". Según la 3FN, los datos deben depender "únicamente de la clave". Para corregir esta anomalía y evitar redundancias masivas, se debe escindir la información en dos tablas: una de Pacientes y otra de Localidades, donde se establezca la relación única entre cada ciudad y su código postal correspondiente.

**Caso 3: Violación de la Segunda Forma Normal (2FN)**
La tabla presenta una dependencia parcial de los atributos respecto a una clave primaria compuesta (PacienteID y MédicoID). El "NombrePaciente" solo depende de una parte de la clave (PacienteID), mientras que la "Especialidad" depende exclusivamente del MédicoID. Para alcanzar la 2FN, es necesario que todos los atributos no clave dependan de la clave completa. La normalización requiere separar estas entidades en tablas independientes de Pacientes y Médicos, manteniendo una tercera tabla intermedia para registrar el vínculo de la atención médica.

**Caso 4: Violación de la Cuarta Forma Normal (4FN)**
Este caso ilustra una dependencia multievaluada, donde se intentan registrar dos hechos independientes entre sí (Enfermedades y Medicamentos) que tienen una relación de muchos a muchos con el paciente. Esto genera un producto cartesiano innecesario y redundante, donde cada enfermedad se repite para cada medicamento. La 4FN exige que estos hechos independientes se almacenen en tablas distintas (una para el historial de diagnósticos y otra para el plan de medicación), eliminando la duplicación de datos y las posibles anomalías al actualizar el registro.
 

---

## PARTE 2: SQL

### Consigna 1 — Índice sobre ciudad
```sql
CREATE INDEX idx_pacientes_ciudad ON Pacientes (ciudad);
```
> No retorna resultados. El índice B-Tree se crea correctamente y permite al motor encontrar y agrupar los valores sin escanear toda la tabla, optimizando las consultas GROUP BY sobre ciudad.

---

### Consigna 2 — Vista con edad dinámica
```sql
CREATE VIEW vista_pacientes_edad AS
SELECT 
    *, 
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, fecha_nacimiento)) AS edad
FROM Pacientes;

SELECT nombre, fecha_nacimiento, edad FROM vista_pacientes_edad;
```

| nombre | fecha_nacimiento | edad |
|---|---|---|
| Luciana Gómez | 1991-07-12 | 34 |
| Ricardo López | 1984-03-22 | 42 |
| Clara Fernández | 1990-09-15 | 35 |
| Marcos Ramírez | 1983-11-10 | 42 |
| Julieta Rodríguez | 1985-06-18 | 40 |
| Santiago Pérez | 1979-02-09 | 47 |
| Florencia Álvarez | 1994-04-21 | 32 |
| Esteban Muñoz | 1993-07-30 | 32 |
| Gabriela Vázquez | 1987-08-25 | 38 |
| Fernando García | 1990-01-14 | 36 |
| María Luisa Torres | 1982-12-07 | 43 |
| Joaquín Castillo | 1995-03-29 | 31 |
| Micaela Gutiérrez | 1988-05-14 | 38 |
| Nicolás Morales | 1992-10-11 | 33 |
| Carolina Figueroa | 1985-09-05 | 40 |
| Gustavo Suárez | 1978-07-23 | 47 |
| Paula Medina | 1997-02-17 | 29 |
| Agustín Romero | 1991-05-21 | 34 |
| Sofía Maldonado | 1994-12-18 | 31 |
| Facundo Paredes | 1983-06-16 | 42 |
| Claudia Rojas | 1989-03-04 | 37 |
| Juan Pérez | 1987-09-13 | 38 |
| Juan Pérez | 1995-04-22 | 31 |
| Tomás Herrera | 2005-06-12 | 20 |
| Valeria Castro | 2010-09-22 | 15 |
| Luis Mendoza | 1975-03-30 | 51 |
| Camila Núñez | 2008-01-15 | 18 |
| Pedro Sánchez | 2001-05-10 | 25 |
| Lucía Herrera | 1999-08-22 | 26 |
| Diego Castro | 1980-01-30 | 46 |
| Marina López | 2007-03-18 | 19 |
| Javier Ortiz | 1972-11-05 | 53 |
| Carla Vega | 2012-07-09 | 13 |
| Hugo Silva | 1965-09-14 | 60 |
| Natalia Ponce | 1993-12-01 | 32 |

---

### Consigna 3 — Pacientes menores de edad
```sql
SELECT nombre, edad
FROM vista_pacientes_edad
WHERE edad < 18;
```

| nombre | edad |
|---|---|
| Valeria Castro | 15 |
| Carla Vega | 13 |

---

### Consigna 4 — Actualizar dirección de Luciana Gómez
```sql
-- Estado anterior
SELECT nombre, calle, numero, ciudad 
FROM Pacientes 
WHERE nombre = 'Luciana Gómez';

-- Actualización
UPDATE Pacientes
SET calle = 'Calle Corrientes',
    numero = '500'
WHERE nombre = 'Luciana Gómez';

-- Verificación
SELECT nombre, calle, numero, ciudad 
FROM Pacientes 
WHERE nombre = 'Luciana Gómez';
```

**Antes:**

| nombre | calle | numero | ciudad |
|---|---|---|---|
| Luciana Gómez | Avenida Las Heras | 121 | Bs Aires |

**Después:**

| nombre | calle | numero | ciudad |
|---|---|---|---|
| Luciana Gómez | Calle Corrientes | 500 | Bs Aires |

---

### Consigna 5 — Médicos con especialidad id=4 (Dermatología)
```sql
SELECT nombre, matricula
FROM Medicos
WHERE especialidad_id = 4;
```

| nombre | matricula |
|---|---|
| Dra. Lucía Rodríguez | 89012 |
| Dr. Nicolás Gutiérrez | 90123 |
| Dra. Paula Ortiz | 99902 |

---

### Consigna 6 — Pacientes de Buenos Aires con dirección
```sql
SELECT nombre, calle || ' ' || numero AS direccion
FROM Pacientes
WHERE TRIM(ciudad) ILIKE 'Buenos %Aires%'
   OR TRIM(ciudad) ILIKE 'Buenos Aiers%'
   OR TRIM(ciudad) ILIKE 'Bs%Aires%';
```

| nombre | direccion |
|---|---|
| Julieta Rodríguez | Calle Mitre 845 |
| Santiago Pérez | Calle Balcarce 1103 |
| Micaela Gutiérrez | Avenida Sarmiento 776 |
| Nicolás Morales | Calle Rivadavia 923 |
| Carolina Figueroa | Calle Rivadavia 135 |
| Agustín Romero | Calle 25 de Mayo 853 |
| Sofía Maldonado | Avenida Libertador 492 |
| Valeria Castro | Calle Perú 122 |
| Pedro Sánchez | Calle Salta 321 |
| Lucía Herrera | Av. Rivadavia 876 |
| Luciana Gómez | Calle Corrientes 500 |

---

### Consigna 7 — Corregir inconsistencias en nombres de ciudades
```sql
UPDATE Pacientes SET ciudad = 'Buenos Aires'
WHERE TRIM(ciudad) ILIKE 'B% Aires' 
   OR TRIM(ciudad) ILIKE 'Buenos %Aiers%';

UPDATE Pacientes SET ciudad = 'Córdoba'
WHERE TRIM(ciudad) ILIKE 'C%r%ba';

UPDATE Pacientes SET ciudad = 'Mendoza'
WHERE TRIM(ciudad) ILIKE 'Mend%a';

UPDATE Pacientes SET ciudad = 'Rosario'
WHERE TRIM(ciudad) ILIKE 'Rosario';

SELECT DISTINCT ciudad FROM Pacientes ORDER BY ciudad ASC;
```

| ciudad |
|---|
| Buenos Aires |
| Córdoba |
| Mendoza |
| Rosario |
| Santa Fe |

---

### Consigna 8 — Cantidad de pacientes por ciudad
```sql
SELECT ciudad, COUNT(*) AS cantidad_pacientes
FROM Pacientes
GROUP BY ciudad
ORDER BY cantidad_pacientes DESC;
```

| ciudad | cantidad_pacientes |
|---|---|
| Buenos Aires | 11 |
| Córdoba | 9 |
| Rosario | 7 |
| Mendoza | 6 |
| Santa Fe | 2 |

---

### Consigna 9 — Cantidad de pacientes por sexo y ciudad
```sql
SELECT p.ciudad, s.descripcion AS sexo, COUNT(*) AS cantidad
FROM Pacientes p
INNER JOIN SexoBiologico s ON p.id_sexo = s.id_sexo
GROUP BY p.ciudad, s.descripcion
ORDER BY p.ciudad ASC, cantidad DESC;
```

| ciudad | sexo | cantidad |
|---|---|---|
| Buenos Aires | Femenino | 7 |
| Buenos Aires | Masculino | 4 |
| Córdoba | Femenino | 5 |
| Córdoba | Masculino | 4 |
| Mendoza | Masculino | 4 |
| Mendoza | Femenino | 2 |
| Rosario | Masculino | 5 |
| Rosario | Femenino | 2 |
| Santa Fe | Femenino | 1 |
| Santa Fe | Masculino | 1 |

---

### Consigna 10 — Cantidad de recetas por médico
```sql
SELECT m.nombre AS medico, COUNT(r.id_receta) AS total_recetas
FROM Medicos m
LEFT JOIN Recetas r ON m.id_medico = r.id_medico
GROUP BY m.id_medico, m.nombre
ORDER BY total_recetas DESC;
```

| id_medico | medico | total_recetas |
|---|---|---|
| 9 | Dr. Nicolás Gutiérrez | 7 |
| 2 | Dra. Laura Fernández | 7 |
| 8 | Dra. Lucía Rodríguez | 6 |
| 1 | Dr. Carlos García | 6 |
| 3 | Dr. Pedro Ruiz | 5 |
| 7 | Dra. Carolina Méndez | 4 |
| 10 | Dra. Mónica Silva | 4 |
| 4 | Dra. Gabriela Fernández | 4 |
| 5 | Dr. José Álvarez | 1 |
| 6 | Dr. Martín Sánchez | 1 |
| 16 | Dra. Marta Ávila | 0 |
| 12 | Dra. Valentina López | 0 |
| 24 | Dra. Daniela Ríos | 0 |
| 22 | Dra. Elena Torres | 0 |
| 23 | Dr. Bruno Acosta | 0 |
| 15 | Dr. Mateo González | 0 |
| 19 | Dr. Federico Luna | 0 |
| 14 | Dra. Alicia Ramírez | 0 |
| 13 | Dr. Sebastián Pérez | 0 |
| 20 | Dra. Paula Ortiz | 0 |
| 18 | Dr. Juan Muñoz | 0 |
| 11 | Dr. Andrés Vázquez | 0 |
| 21 | Dr. Roberto Díaz | 0 |
| 17 | Dr. Pablo Martínez | 0 |

---

### Consigna 11 — Consultas del médico id=3 en agosto 2024
```sql
SELECT *
FROM Consultas
WHERE id_medico = 3
  AND fecha BETWEEN '2024-08-01' AND '2024-08-31';
```

| id_consulta | id_paciente | id_medico | fecha | diagnostico | tratamiento | snomed_codigo |
|---|---|---|---|---|---|---|
| 24 | 16 | 3 | 2024-08-08 | Dolor de pecho | | 29857009 |
| 32 | 18 | 3 | 2024-08-16 | Hipertensión arterial | | 59621000 |
| 45 | 5 | 3 | 2024-08-29 | Dolor de pecho | | 29857009 |

---

### Consigna 12 — Pacientes, fecha y diagnóstico en agosto 2024
```sql
SELECT p.nombre, c.fecha, c.diagnostico
FROM Consultas c
JOIN Pacientes p ON c.id_paciente = p.id_paciente
WHERE c.fecha BETWEEN '2024-08-01' AND '2024-08-31';
```

| nombre | fecha | diagnostico |
|---|---|---|
| Marcos Ramírez | 2024-08-14 | Degeneración macular |
| Julieta Rodríguez | 2024-08-29 | Dolor de pecho |
| Julieta Rodríguez | 2024-08-15 | Problemas de visión |
| Santiago Pérez | 2024-08-23 | Bronquitis crónica |
| Micaela Gutiérrez | 2024-08-27 | Trastorno de pánico |
| Nicolás Morales | 2024-08-11 | Infección de oído |
| Carolina Figueroa | 2024-08-21 | Trastorno bipolar |
| Carolina Figueroa | 2024-08-12 | Fractura de muñeca |
| Agustín Romero | 2024-08-30 | Fractura de fémur |
| Agustín Romero | 2024-08-16 | Hipertensión arterial |
| Agustín Romero | 2024-08-05 | Ansiedad |
| Sofía Maldonado | 2024-08-25 | Ansiedad generalizada |
| Sofía Maldonado | 2024-08-03 | Sinusitis |
| Valeria Castro | 2024-08-20 | Dolor lumbar |
| Florencia Álvarez | 2024-08-06 | Luxación de hombro |
| Esteban Muñoz | 2024-08-01 | Bronquitis |
| María Luisa Torres | 2024-08-24 | Gastritis crónica |
| María Luisa Torres | 2024-08-02 | Luxación de hombro |
| Gustavo Suárez | 2024-08-28 | Cataratas |
| Gustavo Suárez | 2024-08-08 | Dolor de pecho |
| Paula Medina | 2024-08-13 | Trastorno bipolar |
| Gabriela Vázquez | 2024-08-20 | Psoriasis |
| Gabriela Vázquez | 2024-08-07 | Eccema |
| Fernando García | 2024-08-17 | Trastorno obsesivo-compulsivo |
| Juan Pérez | 2024-08-26 | Dermatitis atópica |
| Juan Pérez | 2024-08-04 | Fractura de pierna |
| Ricardo López | 2024-08-31 | Infección de oído crónica |
| Clara Fernández | 2024-08-18 | Fractura de tobillo |
| Clara Fernández | 2024-08-09 | Gastritis |
| Joaquín Castillo | 2024-08-22 | Luxación de codo |
| Joaquín Castillo | 2024-08-10 | Asma crónico |
| Facundo Paredes | 2024-08-19 | Depresión severa |
| Tomás Herrera | 2024-08-15 | Resfriado leve |

---

### Consigna 13 — Medicamentos recetados más de una vez por médico id=2
```sql
SELECT med.nombre, COUNT(*) AS veces_recetado
FROM Recetas r
JOIN Medicamentos med ON r.id_medicamento = med.id_medicamento
WHERE r.id_medico = 2
GROUP BY med.nombre
HAVING COUNT(*) > 1;
```

| nombre | veces_recetado |
|---|---|
| Omeprazol | 4 |

---

### Consigna 14 — Pacientes y total de recetas recibidas
```sql
SELECT p.nombre, COUNT(r.id_receta) AS total_recetas
FROM Pacientes p
LEFT JOIN Recetas r ON p.id_paciente = r.id_paciente
GROUP BY p.nombre
ORDER BY total_recetas DESC;
```

| nombre | total_recetas |
|---|---|
| Ricardo López | 3 |
| Gabriela Vázquez | 3 |
| Florencia Álvarez | 3 |
| Marcos Ramírez | 3 |
| Paula Medina | 2 |
| Luciana Gómez | 2 |
| Clara Fernández | 2 |
| Julieta Rodríguez | 2 |
| Sofía Maldonado | 2 |
| Fernando García | 2 |
| Joaquín Castillo | 2 |
| Esteban Muñoz | 2 |
| Santiago Pérez | 2 |
| Nicolás Morales | 2 |
| María Luisa Torres | 2 |
| Carolina Figueroa | 2 |
| Juan Pérez | 1 |
| Luis Mendoza | 1 |
| Gustavo Suárez | 1 |
| Facundo Paredes | 1 |
| Micaela Gutiérrez | 1 |
| Tomás Herrera | 1 |
| Claudia Rojas | 1 |
| Valeria Castro | 1 |
| Agustín Romero | 1 |
| Diego Castro | 0 |
| Hugo Silva | 0 |
| Camila Núñez | 0 |
| Lucía Herrera | 0 |
| Pedro Sánchez | 0 |
| Natalia Ponce | 0 |
| Carla Vega | 0 |
| Javier Ortiz | 0 |
| Marina López | 0 |

---

### Consigna 15 — Medicamento más recetado
```sql
SELECT med.nombre, COUNT(*) AS total_recetas
FROM Recetas r
JOIN Medicamentos med ON r.id_medicamento = med.id_medicamento
GROUP BY med.nombre
ORDER BY total_recetas DESC
LIMIT 1;
```

| nombre | total_recetas |
|---|---|
| Férula | 5 |

---

### Consigna 16 — Última consulta de cada paciente con diagnóstico
```sql
SELECT p.nombre, c.fecha, c.diagnostico
FROM Consultas c
JOIN Pacientes p ON c.id_paciente = p.id_paciente
WHERE c.fecha = (
    SELECT MAX(c2.fecha)
    FROM Consultas c2
    WHERE c2.id_paciente = c.id_paciente
);
```

| nombre | fecha | diagnostico |
|---|---|---|
| Marcos Ramírez | 2024-09-18 | Acné leve |
| Julieta Rodríguez | 2024-09-19 | Dolor muscular |
| Santiago Pérez | 2024-09-20 | Arritmia |
| Micaela Gutiérrez | 2024-08-27 | Trastorno de pánico |
| Nicolás Morales | 2024-09-02 | Fractura de muñeca |
| Carolina Figueroa | 2024-09-07 | Cataratas avanzadas |
| Agustín Romero | 2024-09-10 | Resfriado común |
| Sofía Maldonado | 2024-09-14 | Luxación de hombro crónica |
| Valeria Castro | 2024-08-20 | Dolor lumbar |
| Luciana Gómez | 2024-09-25 | Bronquitis |
| Florencia Álvarez | 2024-09-21 | Glaucoma |
| Esteban Muñoz | 2024-09-22 | Ansiedad |
| María Luisa Torres | 2024-09-06 | Trastorno de ansiedad generalizada |
| Gustavo Suárez | 2024-08-28 | Cataratas |
| Paula Medina | 2024-09-03 | Trastorno bipolar grave |
| Gabriela Vázquez | 2024-09-23 | Fractura leve |
| Fernando García | 2024-09-24 | Diabetes |
| Claudia Rojas | 2024-07-26 | Dolor de cabeza crónico |
| Juan Pérez | 2024-09-12 | Psoriasis grave |
| Luis Mendoza | 2024-09-01 | Migraña |
| Ricardo López | 2024-09-26 | Gastritis |
| Clara Fernández | 2024-09-17 | Hipertensión |
| Joaquín Castillo | 2024-08-22 | Luxación de codo |
| Facundo Paredes | 2024-09-08 | Fractura de clavícula |
| Tomás Herrera | 2024-08-15 | Resfriado leve |

---

### Consigna 17 — Consultas por par médico-paciente
```sql
SELECT m.nombre AS medico, p.nombre AS paciente, COUNT(*) AS total_consultas
FROM Consultas c
JOIN Medicos m ON c.id_medico = m.id_medico
JOIN Pacientes p ON c.id_paciente = p.id_paciente
GROUP BY m.nombre, p.nombre
ORDER BY m.nombre ASC, p.nombre ASC;
```

| medico | paciente | total_consultas |
|---|---|---|
| Dr. Carlos García | Agustín Romero | 1 |
| Dr. Carlos García | Esteban Muñoz | 1 |
| Dr. Carlos García | Florencia Álvarez | 2 |
| Dr. Carlos García | Joaquín Castillo | 1 |
| Dr. Carlos García | Luciana Gómez | 2 |
| Dr. Carlos García | Santiago Pérez | 1 |
| Dr. Carlos García | Tomás Herrera | 1 |
| Dr. José Álvarez | Julieta Rodríguez | 1 |
| Dr. Martín Sánchez | Santiago Pérez | 1 |
| Dr. Nicolás Gutiérrez | Agustín Romero | 1 |
| Dr. Nicolás Gutiérrez | Carolina Figueroa | 1 |
| Dr. Nicolás Gutiérrez | Clara Fernández | 1 |
| Dr. Nicolás Gutiérrez | Facundo Paredes | 1 |
| Dr. Nicolás Gutiérrez | Florencia Álvarez | 1 |
| Dr. Nicolás Gutiérrez | Gabriela Vázquez | 1 |
| Dr. Nicolás Gutiérrez | Joaquín Castillo | 1 |
| Dr. Nicolás Gutiérrez | Juan Pérez | 1 |
| Dr. Nicolás Gutiérrez | María Luisa Torres | 1 |
| Dr. Nicolás Gutiérrez | Nicolás Morales | 1 |
| Dr. Nicolás Gutiérrez | Ricardo López | 1 |
| Dr. Nicolás Gutiérrez | Sofía Maldonado | 1 |
| Dr. Pedro Ruiz | Agustín Romero | 1 |
| Dr. Pedro Ruiz | Clara Fernández | 1 |
| Dr. Pedro Ruiz | Gustavo Suárez | 1 |
| Dr. Pedro Ruiz | Julieta Rodríguez | 1 |
| Dr. Pedro Ruiz | Luis Mendoza | 1 |
| Dr. Pedro Ruiz | Marcos Ramírez | 1 |
| Dr. Pedro Ruiz | Santiago Pérez | 1 |
| Dra. Carolina Méndez | Carolina Figueroa | 1 |
| Dra. Carolina Méndez | Facundo Paredes | 1 |
| Dra. Carolina Méndez | Florencia Álvarez | 1 |
| Dra. Carolina Méndez | Gabriela Vázquez | 1 |
| Dra. Carolina Méndez | Gustavo Suárez | 1 |
| Dra. Carolina Méndez | Julieta Rodríguez | 1 |
| Dra. Carolina Méndez | Marcos Ramírez | 1 |
| Dra. Gabriela Fernández | Gabriela Vázquez | 3 |
| Dra. Gabriela Fernández | Joaquín Castillo | 1 |
| Dra. Gabriela Fernández | Juan Pérez | 2 |
| Dra. Gabriela Fernández | Marcos Ramírez | 1 |
| Dra. Gabriela Fernández | Nicolás Morales | 1 |
| Dra. Laura Fernández | Carolina Figueroa | 1 |
| Dra. Laura Fernández | Clara Fernández | 2 |
| Dra. Laura Fernández | Esteban Muñoz | 1 |
| Dra. Laura Fernández | Fernando García | 1 |
| Dra. Laura Fernández | Julieta Rodríguez | 1 |
| Dra. Laura Fernández | María Luisa Torres | 1 |
| Dra. Laura Fernández | Ricardo López | 2 |
| Dra. Laura Fernández | Sofía Maldonado | 1 |
| Dra. Laura Fernández | Valeria Castro | 1 |
| Dra. Lucía Rodríguez | Agustín Romero | 1 |
| Dra. Lucía Rodríguez | Carolina Figueroa | 1 |
| Dra. Lucía Rodríguez | Claudia Rojas | 1 |
| Dra. Lucía Rodríguez | Esteban Muñoz | 1 |
| Dra. Lucía Rodríguez | Facundo Paredes | 1 |
| Dra. Lucía Rodríguez | Fernando García | 1 |
| Dra. Lucía Rodríguez | Julieta Rodríguez | 1 |
| Dra. Lucía Rodríguez | María Luisa Torres | 2 |
| Dra. Lucía Rodríguez | Micaela Gutiérrez | 1 |
| Dra. Lucía Rodríguez | Paula Medina | 3 |
| Dra. Lucía Rodríguez | Santiago Pérez | 1 |
| Dra. Lucía Rodríguez | Sofía Maldonado | 1 |
| Dra. Mónica Silva | Fernando García | 1 |
| Dra. Mónica Silva | Micaela Gutiérrez | 1 |
| Dra. Mónica Silva | Nicolás Morales | 1 |
| Dra. Mónica Silva | Ricardo López | 1 |
| Dra. Mónica Silva | Sofía Maldonado | 1 |

---

### Consigna 18 — Medicamento, recetas, médico y paciente
```sql
SELECT med.nombre AS medicamento, COUNT(*) AS total_recetas,
       m.nombre AS medico, p.nombre AS paciente
FROM Recetas r
JOIN Medicamentos med ON r.id_medicamento = med.id_medicamento
JOIN Medicos m ON r.id_medico = m.id_medico
JOIN Pacientes p ON r.id_paciente = p.id_paciente
GROUP BY med.nombre, m.nombre, p.nombre
ORDER BY total_recetas DESC;
```

| medicamento | total_recetas | medico | paciente |
|---|---|---|---|
| Omeprazol | 2 | Dra. Laura Fernández | Ricardo López |
| Colirio para glaucoma | 1 | Dra. Carolina Méndez | Gabriela Vázquez |
| Ibuprofeno | 1 | Dr. José Álvarez | Julieta Rodríguez |
| Férula | 1 | Dr. Nicolás Gutiérrez | Gabriela Vázquez |
| Férula | 1 | Dr. Nicolás Gutiérrez | Carolina Figueroa |
| Amoxicilina | 1 | Dr. Carlos García | Florencia Álvarez |
| Omeprazol | 1 | Dra. Laura Fernández | Clara Fernández |
| Sertralina | 1 | Dra. Lucía Rodríguez | María Luisa Torres |
| Sertralina | 1 | Dra. Lucía Rodríguez | Agustín Romero |
| Atorvastatina | 1 | Dra. Mónica Silva | Micaela Gutiérrez |
| Paracetamol | 1 | Dr. Carlos García | Tomás Herrera |
| Paracetamol | 1 | Dr. Carlos García | Joaquín Castillo |
| Colirio para glaucoma | 1 | Dra. Carolina Méndez | Facundo Paredes |
| Hidrocortisona | 1 | Dra. Gabriela Fernández | Gabriela Vázquez |
| Metformina | 1 | Dra. Mónica Silva | Fernando García |
| Amoxicilina | 1 | Dr. Carlos García | Luciana Gómez |
| Férula | 1 | Dr. Nicolás Gutiérrez | Julieta Rodríguez |
| Colirio para glaucoma | 1 | Dra. Carolina Méndez | Florencia Álvarez |
| Omeprazol | 1 | Dra. Laura Fernández | Carolina Figueroa |
| Terapia cognitivo-conductual | 1 | Dra. Lucía Rodríguez | Paula Medina |
| Paracetamol | 1 | Dr. Carlos García | Luciana Gómez |
| Amoxicilina + ácido clavulánico | 1 | Dra. Mónica Silva | Sofía Maldonado |
| Losartán | 1 | Dr. Pedro Ruiz | Marcos Ramírez |
| Ibuprofeno | 1 | Dra. Laura Fernández | Valeria Castro |
| Reposo absoluto | 1 | Dr. Nicolás Gutiérrez | Ricardo López |
| Amoxicilina | 1 | Dra. Laura Fernández | Fernando García |
| Atorvastatina | 1 | Dr. Martín Sánchez | Santiago Pérez |
| Aspirina | 1 | Dr. Pedro Ruiz | Luis Mendoza |
| Losartán | 1 | Dr. Pedro Ruiz | Clara Fernández |
| Sertralina | 1 | Dra. Lucía Rodríguez | Paula Medina |
| Amoxicilina | 1 | Dr. Carlos García | Esteban Muñoz |
| Reposo absoluto | 1 | Dr. Nicolás Gutiérrez | Florencia Álvarez |
| Hidrocortisona | 1 | Dra. Gabriela Fernández | Marcos Ramírez |
| Hidrocortisona | 1 | Dra. Gabriela Fernández | Joaquín Castillo |
| Losartán | 1 | Dr. Pedro Ruiz | Gustavo Suárez |
| Hidrocortisona | 1 | Dra. Gabriela Fernández | Nicolás Morales |
| Férula | 1 | Dr. Nicolás Gutiérrez | María Luisa Torres |
| Losartán | 1 | Dr. Pedro Ruiz | Santiago Pérez |
| Sertralina | 1 | Dra. Lucía Rodríguez | Esteban Muñoz |
| Amoxicilina + ácido clavulánico | 1 | Dra. Laura Fernández | Sofía Maldonado |
| Férula | 1 | Dr. Nicolás Gutiérrez | Juan Pérez |
| Ibuprofeno | 1 | Dra. Lucía Rodríguez | Claudia Rojas |
| Amoxicilina + ácido clavulánico | 1 | Dra. Mónica Silva | Nicolás Morales |

---

### Consigna 19 — Médico y total de pacientes atendidos
```sql
SELECT m.nombre, COUNT(DISTINCT c.id_paciente) AS total_pacientes
FROM Consultas c
JOIN Medicos m ON c.id_medico = m.id_medico
GROUP BY m.nombre
ORDER BY total_pacientes DESC;
```

| nombre | total_pacientes |
|---|---|
| Dr. Nicolás Gutiérrez | 12 |
| Dra. Lucía Rodríguez | 12 |
| Dra. Laura Fernández | 9 |
| Dr. Carlos García | 7 |
| Dr. Pedro Ruiz | 7 |
| Dra. Carolina Méndez | 7 |
| Dra. Gabriela Fernández | 5 |
| Dra. Mónica Silva | 5 |
| Dr. Martín Sánchez | 1 |
| Dr. José Álvarez | 1 |

---

### Consigna 20 — Consultas a menores de edad por médico
```sql
SELECT m.nombre AS medico, COUNT(*) AS consultas_a_menores
FROM Consultas c
JOIN Medicos m ON c.id_medico = m.id_medico
JOIN Pacientes p ON c.id_paciente = p.id_paciente
WHERE EXTRACT(YEAR FROM AGE(c.fecha, p.fecha_nacimiento)) < 18
GROUP BY m.nombre
ORDER BY consultas_a_menores DESC;
```

| medico | consultas_a_menores |
|---|---|
| Dra. Laura Fernández | 1 |


