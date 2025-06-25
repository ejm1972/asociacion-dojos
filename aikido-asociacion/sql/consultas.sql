✅ 1. Listar todos los instructores de un dojo (por nombre)

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

✅ 2. Listar todos los dojos donde una persona es instructor

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

    También podés filtrar por p.id = X si tenés el ID directamente.

✅ 3. Listar los instructores principales de todos los dojos

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

✅ 4. Listar dojos con su responsable administrativo (si tiene)

SELECT
    d.nombre AS dojo,
    p.nombre AS responsable_nombre,
    p.apellido AS responsable_apellido,
    d.mail,
    d.celular
FROM dojos d
LEFT JOIN personas p ON d.responsable_admin_id = p.id;

🔎 3. Consultas SELECT útiles

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