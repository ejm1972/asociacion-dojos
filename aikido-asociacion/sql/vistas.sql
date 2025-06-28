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
--
    ra.nombre AS responsable_nombre,
    ra.apellido AS responsable_apellido,
    ra.email AS responsable_email,
    ra.telefono AS responsable_telefono,
--
    ip.nombre AS instructor_principal_nombre,
    ip.apellido AS instructor_principal_apellido,
    ipd.grado AS instructor_principal_grado,
    ipd.desde_fecha AS instructor_principal_desde
--
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

-- Vista: estado de cuotas por persona
CREATE VIEW vista_estado_cuotas AS
SELECT 
    p.id AS persona_id,
    p.nombre,
    p.apellido,
    c.periodo_mes,
    c.periodo_anio,
    c.monto,
    c.pagado,
    c.vencida,
    c.condonada,
    c.metodo_pago,
    c.fecha_pago
FROM personas p
LEFT JOIN cuotas c ON c.persona_id = p.id
ORDER BY p.nombre, p.apellido, c.periodo_anio, c.periodo_mes;

-- Vista obtener graduación actual
CREATE VIEW vista_graduacion_actual AS
SELECT h1.*
FROM historial_graduaciones h1
JOIN (
    SELECT persona_id, MAX(fecha) AS fecha_max
    FROM historial_graduaciones
    GROUP BY persona_id
) h2
ON h1.persona_id = h2.persona_id AND h1.fecha = h2.fecha_max;

-- Vista: vista_estado_actual_personas
CREATE VIEW vista_estado_actual_personas AS
SELECT
  p.id AS persona_id,
  p.nombre,
  p.apellido,
  p.dni,
  p.email,
  p.telefono,
  p.graduacion_actual,
--  
  d.nombre AS dojo_actual_nombre,
  d.ciudad AS dojo_actual_ciudad,
--  
  c.periodo_mes AS ultimo_mes_pagado,
  c.periodo_anio AS ultimo_anio_pagado,
  c.monto AS ultimo_monto_pagado,
  c.fecha_pago AS fecha_ultimo_pago,
  c.metodo_pago
--  
FROM personas p
LEFT JOIN dojos d ON p.dojo_actual_id = d.id
--
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
) c ON p.id = c.persona_id;

