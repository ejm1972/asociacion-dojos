USE aikido_asociacion;

-- Usuario por defecto: admin / admin123
INSERT INTO usuarios (username, password, rol)
VALUES ('admin', '$2y$10$ArV7Fud75Zn5J01EXroNTOpUw2ALJ6mHbpRKCBfL6PMKq9CPrI5Ke', 'admin'); 
-- La contraseña 'admin123' fue hasheada con password_hash

INSERT INTO personas (nombre, apellido, email, telefono)
VALUES 
  ('Carlos', 'Pérez', 'carlos.perez@aikido.org', '341-1111111'),  -- id = 1
  ('Lucía', 'Gómez', 'lucia.gomez@aikido.org', '341-2222222'),    -- id = 2
  ('Juan', 'Lopez', 'juan.lopez@aikido.org', '341-3333333');      -- id = 3

INSERT INTO dojos (
    nombre, ciudad, provincia, pais, direccion, 
    fecha_inicio, rama_dependencia, fecha_ingreso_ada,
    responsable_admin_id, celular, mail, observaciones
) VALUES 
  (
    'Aikido Rosario Dojo',
    'Rosario',
    'Santa Fe',
    'Argentina',
    'Bv. Oroño 1234',
    '2005-03-01',
    'Rama Central Aikikai',
    '2010-05-20',
    1,
    '341-9999999',
    'dojo.rosario@aikido.org',
    'Primer dojo fundado en Rosario.'
  ),
  (
    'Aikido Córdoba Dojo',
    'Córdoba',
    'Córdoba',
    'Argentina',
    'Av. Colón 4567',
    '2012-06-15',
    'Rama Oeste',
    '2015-08-10',
    2,
    '351-8888888',
    'cordoba@aikido.org',
    'Afiliado recientemente a ADA.'
  );

-- Dojo 1: Rosario
INSERT INTO instructores_por_dojo (dojo_id, persona_id, rol, grado, desde_fecha)
VALUES
  (1, 1, 'principal', '4º Dan', '2005-03-01'),
  (1, 3, 'adjunto', '2º Dan', '2021-01-01');

-- Dojo 2: Córdoba
INSERT INTO instructores_por_dojo (dojo_id, persona_id, rol, grado, desde_fecha)
VALUES
  (2, 2, 'principal', '3º Dan', '2012-06-15');

SELECT * FROM vista_dojos_completa;
SELECT * FROM vista_instructores_por_dojo;

-- Personas
INSERT INTO personas (id, nombre_completo, dni, fecha_nacimiento, email, telefono)
VALUES
(1, 'Juan Pérez', '12345678', '1990-03-15', 'juan@example.com', '1111-1111'),
(2, 'Laura Gómez', '23456789', '1985-07-22', 'laura@example.com', '2222-2222'),
(3, 'Carlos Díaz', '34567890', '1980-12-01', 'carlos@example.com', '3333-3333'),
(4, 'Sofía Ruiz', '45678901', '2000-06-10', 'sofia@example.com', '4444-4444');

-- Dojo
INSERT INTO dojos (id, nombre, ciudad, provincia, pais, direccion, fecha_inicio, rama_dependencia, fecha_ingreso_ada, celular, mail)
VALUES
(1, 'Dojo Central', 'Buenos Aires', 'Buenos Aires', 'Argentina', 'Av. Siempre Viva 123', '2010-01-01', 'Shimbukan', '2012-05-15', '1134567890', 'dojo@central.com');

-- Juan Pérez como instructor principal desde 2020
INSERT INTO instructores_por_dojo (dojo_id, persona_id, rol, grado, desde_fecha)
VALUES
(1, 1, 'principal', '3er Dan', '2020-03-01');

-- Participación en el dojo
INSERT INTO personas_por_dojo (persona_id, dojo_id, desde_fecha)
VALUES
(2, 1, '2023-02-01'),  -- Laura
(3, 1, '2024-01-15'),  -- Carlos
(4, 1, '2024-03-01');  -- Sofía

-- Historial de graduaciones
INSERT INTO historial_graduaciones (persona_id, fecha, graduacion, dojo_id, instructor_id, observaciones)
VALUES
(2, '2024-11-15', '5º Kyu', 1, 1, 'Examen inicial'),
(3, '2022-08-10', '1er Dan', 1, 1, 'Promoción por méritos'),
(4, '2025-05-20', '6º Kyu', 1, 1, 'Buena técnica básica'),
(2, '2025-06-01', '4º Kyu', 1, 1, 'Progreso notable desde el anterior');

-- Cuotas pagadas
INSERT INTO cuotas (persona_id, fecha_pago, periodo_mes, periodo_anio, monto, metodo_pago)
VALUES
(2, '2025-03-10', 3, 2025, 4500.00, 'transferencia'),
(2, '2025-04-10', 4, 2025, 4500.00, 'efectivo'),
(3, '2025-03-05', 3, 2025, 4500.00, 'efectivo'),
(4, '2025-04-15', 4, 2025, 4500.00, 'transferencia');
-- Registro de una cuota de marzo 2025
INSERT INTO cuotas (persona_id, fecha_pago, periodo_mes, periodo_anio, monto, metodo_pago)
VALUES (1, '2025-03-05', 3, 2025, 4500.00, 'transferencia');

-- Asistencia mensual
INSERT INTO asistencia_mensual (persona_id, dojo_id, periodo_mes, periodo_anio, cantidad_clases, observaciones, registrado_por_id)
VALUES
(2, 1, 3, 2025, 7, 'Buena asistencia', 1),
(2, 1, 4, 2025, 8, 'Asistió a todas', 1),
(3, 1, 3, 2025, 6, 'Faltó una semana por viaje', 1),
(4, 1, 4, 2025, 4, 'Ausencias justificadas por estudios', 1);

-- Registrar que Juan Pérez asistió a 8 clases en mayo 2025 en Dojo N°3
INSERT INTO asistencia_mensual (
    persona_id, dojo_id, periodo_mes, periodo_anio, cantidad_clases, observaciones, registrado_por_id
) VALUES (
    1, 3, 5, 2025, 8, 'Participación completa del mes', 12
);