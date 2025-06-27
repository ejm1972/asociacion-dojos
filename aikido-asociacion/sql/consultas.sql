--✅ 1. Listar todos los instructores de un dojo (por nombre)
--
SELECT
    d.nombre AS dojo,
    p.nombre,
    p.apellido,
    ipd.rol,
    ipd.grado,
    ipd.desde_fecha
FROM instructores_por_dojo ipd
JOIN personas p ON ipd.persona_id = p.id
JOIN dojos d ON ipd.dojo_id = d.id
WHERE d.nombre = 'Aikido Rosario Dojo';

--✅ 2. Listar todos los dojos donde una persona es instructor
--
SELECT
    p.nombre,
    p.apellido,
    d.nombre AS dojo,
    ipd.rol,
    ipd.grado,
    ipd.desde_fecha
FROM instructores_por_dojo ipd
JOIN personas p ON ipd.persona_id = p.id
JOIN dojos d ON ipd.dojo_id = d.id
WHERE p.apellido = 'Pérez';
--También podés filtrar por p.id = X si tenés el ID directamente.

--✅ 3. Listar los instructores principales de todos los dojos
--
SELECT
    d.nombre AS dojo,
    p.nombre,
    p.apellido,
    ipd.grado
FROM instructores_por_dojo ipd
JOIN personas p ON ipd.persona_id = p.id
JOIN dojos d ON ipd.dojo_id = d.id
WHERE ipd.rol = 'principal'
ORDER BY d.nombre;

--✅ 4. Listar dojos con su responsable administrativo (si tiene)
--
SELECT
    d.nombre AS dojo,
    p.nombre AS responsable_nombre,
    p.apellido AS responsable_apellido,
    d.mail,
    d.celular
FROM dojos d
LEFT JOIN personas p ON d.responsable_admin_id = p.id;

--🔎 3. Consultas SELECT útiles
--
-- Listar todos los instructores de un dojo específico
SELECT
    d.nombre AS dojo,
    p.nombre,
    p.apellido,
    ipd.rol,
    ipd.grado,
    ipd.desde_fecha
FROM instructores_por_dojo ipd
JOIN personas p ON ipd.persona_id = p.id
JOIN dojos d ON ipd.dojo_id = d.id
WHERE d.nombre = 'Aikido Rosario Dojo';

-- Listar todos los dojos donde participa un instructor específico
SELECT
    p.nombre,
    p.apellido,
    d.nombre AS dojo,
    ipd.rol,
    ipd.grado,
    ipd.desde_fecha
FROM instructores_por_dojo ipd
JOIN personas p ON ipd.persona_id = p.id
JOIN dojos d ON ipd.dojo_id = d.id
WHERE p.apellido = 'Pérez';

-- Listar todos los instructores principales de todos los dojos
SELECT
    d.nombre AS dojo,
    p.nombre,
    p.apellido,
    ipd.grado
FROM instructores_por_dojo ipd
JOIN personas p ON ipd.persona_id = p.id
JOIN dojos d ON ipd.dojo_id = d.id
WHERE ipd.rol = 'principal'
ORDER BY d.nombre;

-- Listar dojos con su responsable administrativo
SELECT
    d.nombre AS dojo,
    p.nombre AS responsable_nombre,
    p.apellido AS responsable_apellido,
    d.mail,
    d.celular
FROM dojos d
LEFT JOIN personas p ON d.responsable_admin_id = p.id;

-- Graduación actual de Juan Pérez
SELECT v.graduacion, v.fecha, p.nombre_completo
FROM vista_graduacion_actual v
JOIN personas p ON v.persona_id = p.id
WHERE p.nombre_completo = 'Juan Pérez';

--🔎 1. Personas sin dojo actual
SELECT *
FROM personas
WHERE dojo_actual_id IS NULL;

--🔎 2. Personas con cuota vencida (último pago anterior a mayo 2025, por ejemplo)
SELECT p.id, p.nombre_completo, c.periodo_mes, c.periodo_anio, c.fecha_pago
FROM personas p
LEFT JOIN (
  SELECT c1.*
  FROM cuotas c1
  JOIN (
    SELECT persona_id, MAX(CONCAT(periodo_anio, LPAD(periodo_mes, 2, '0'))) AS periodo_max
    FROM cuotas
    WHERE pagado = TRUE
    GROUP BY persona_id
  ) c2
  ON c1.persona_id = c2.persona_id
     AND CONCAT(c1.periodo_anio, LPAD(c1.periodo_mes, 2, '0')) = c2.periodo_max
) c ON p.id = c.persona_id
WHERE CONCAT(c.periodo_anio, LPAD(c.periodo_mes, 2, '0')) < '202505';

--🔎 3. Personas que nunca pagaron cuota
SELECT p.*
FROM personas p
LEFT JOIN cuotas c ON p.id = c.persona_id
WHERE c.id IS NULL;

--🔎 4. Personas que son instructores activos
SELECT DISTINCT p.id, p.nombre_completo, i.rol, d.nombre AS dojo
FROM instructores_por_dojo i
JOIN personas p ON i.persona_id = p.id
JOIN dojos d ON i.dojo_id = d.id
WHERE i.desde_fecha <= CURDATE();

