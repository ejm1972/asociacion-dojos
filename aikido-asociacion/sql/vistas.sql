--📊 2. Vistas: para facilitar reportes y consultas

-- Vista completa con dojo + responsable + instructor principal
CREATE OR REPLACE VIEW vista_dojos_completa AS
SELECT
    d.id AS dojo_id,
    d.nombre AS dojo,
    d.ciudad,
    d.provincia,
    d.pais,
    d.direccion,
    d.fecha_inicio,
    d.rama_dependencia,
    d.fecha_ingreso_ada,
    d.mail AS dojo_mail,
    d.celular AS dojo_celular,
    d.observaciones AS dojo_observaciones,

    ra.nombre AS responsable_nombre,
    ra.apellido AS responsable_apellido,
    ra.email AS responsable_email,
    ra.telefono AS responsable_telefono,

    ip.nombre AS instructor_principal_nombre,
    ip.apellido AS instructor_principal_apellido,
    ipd.grado AS instructor_principal_grado,
    ipd.desde_fecha AS instructor_principal_desde

FROM dojos d
LEFT JOIN personas ra ON d.responsable_admin_id = ra.id
LEFT JOIN instructores_por_dojo ipd ON d.id = ipd.dojo_id AND ipd.rol = 'principal'
LEFT JOIN personas ip ON ipd.persona_id = ip.id;

-- Vista detallada de todos los instructores por dojo
CREATE OR REPLACE VIEW vista_instructores_por_dojo AS
SELECT
    d.id AS dojo_id,
    d.nombre AS dojo,
    d.provincia,
    d.ciudad,
    p.id AS persona_id,
    p.nombre AS instructor_nombre,
    p.apellido AS instructor_apellido,
    ipd.rol,
    ipd.grado,
    ipd.desde_fecha
FROM instructores_por_dojo ipd
JOIN personas p ON ipd.persona_id = p.id
JOIN dojos d ON ipd.dojo_id = d.id
ORDER BY d.nombre, ipd.rol;


