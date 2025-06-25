-- Tabla principal de personas
CREATE TABLE IF NOT EXISTS personas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fecha_inscripcion DATE,
    nombre_completo VARCHAR(100),
    dni VARCHAR(15) UNIQUE,
    fecha_nacimiento DATE,
    lugar_nacimiento VARCHAR(100),
    sexo VARCHAR(10),
    telefono VARCHAR(30),
    nacionalidad VARCHAR(50),
    email VARCHAR(100),
    domicilio_postal TEXT,
    estado_civil VARCHAR(50),
    impedimentos_fisicos TEXT,
    fecha_verificacion_mail DATE,
    observaciones TEXT,
    imagen_dni TEXT,
    firma_digital TEXT,
    graduacion_actual VARCHAR(50),
    dojo_actual_id INT,
    FOREIGN KEY (dojo_actual_id) REFERENCES dojos(id) ON DELETE SET NULL
);

-- Tabla de dojos
CREATE TABLE IF NOT EXISTS dojos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    ciudad VARCHAR(100),
    provincia VARCHAR(100),
    pais VARCHAR(100),
    direccion VARCHAR(150),
    fecha_inicio DATE,
    rama_dependencia VARCHAR(100),
    fecha_ingreso_ada DATE,
    responsable_admin_id INT,
    celular VARCHAR(50),
    mail VARCHAR(100),
    observaciones TEXT,
    FOREIGN KEY (responsable_admin_id) REFERENCES personas(id) ON DELETE SET NULL
);

-- Relación: instructores por dojo
CREATE TABLE IF NOT EXISTS instructores_por_dojo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    dojo_id INT NOT NULL,
    persona_id INT NOT NULL,
    rol ENUM('principal', 'adjunto', 'administrativo') NOT NULL,
    grado VARCHAR(50),
    desde_fecha DATE,
    FOREIGN KEY (dojo_id) REFERENCES dojos(id) ON DELETE CASCADE,
    FOREIGN KEY (persona_id) REFERENCES personas(id) ON DELETE CASCADE
);

-- Participación general en un dojo (historial)
CREATE TABLE IF NOT EXISTS personas_por_dojo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    persona_id INT NOT NULL,
    dojo_id INT NOT NULL,
    desde_fecha DATE,
    hasta_fecha DATE,
    FOREIGN KEY (persona_id) REFERENCES personas(id) ON DELETE CASCADE,
    FOREIGN KEY (dojo_id) REFERENCES dojos(id) ON DELETE CASCADE
);

-- Historial de graduaciones
CREATE TABLE IF NOT EXISTS historial_graduaciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    persona_id INT NOT NULL,
    fecha DATE NOT NULL,
    graduacion VARCHAR(50) NOT NULL,
    dojo_id INT,
    instructor_id INT,
    observaciones TEXT,
    FOREIGN KEY (persona_id) REFERENCES personas(id) ON DELETE CASCADE,
    FOREIGN KEY (dojo_id) REFERENCES dojos(id) ON DELETE SET NULL,
    FOREIGN KEY (instructor_id) REFERENCES personas(id) ON DELETE SET NULL
);

-- Cuotas como membresía a la Asociación
CREATE TABLE IF NOT EXISTS cuotas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    persona_id INT NOT NULL,
    fecha_pago DATE NOT NULL,
    periodo_mes TINYINT NOT NULL,
    periodo_anio SMALLINT NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    metodo_pago VARCHAR(50),
    observaciones TEXT,
    pagado BOOLEAN DEFAULT TRUE,
    vencida BOOLEAN DEFAULT FALSE,
    condonada BOOLEAN DEFAULT FALSE,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (persona_id) REFERENCES personas(id) ON DELETE CASCADE,
    UNIQUE KEY uk_persona_periodo (persona_id, periodo_mes, periodo_anio)
);

-- Registro mensual de asistencia en dojo
CREATE TABLE IF NOT EXISTS asistencia_mensual (
    id INT AUTO_INCREMENT PRIMARY KEY,
    persona_id INT NOT NULL,
    dojo_id INT NOT NULL,
    periodo_mes TINYINT NOT NULL,
    periodo_anio SMALLINT NOT NULL,
    cantidad_clases INT,
    observaciones TEXT,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    registrado_por_id INT,
    FOREIGN KEY (persona_id) REFERENCES personas(id) ON DELETE CASCADE,
    FOREIGN KEY (dojo_id) REFERENCES dojos(id) ON DELETE CASCADE,
    FOREIGN KEY (registrado_por_id) REFERENCES personas(id) ON DELETE SET NULL,
    UNIQUE KEY uk_persona_periodo (persona_id, periodo_mes, periodo_anio)
);

-- Trigger: actualizar graduacion_actual en personas después de INSERT
DELIMITER $$

CREATE TRIGGER actualizar_graduacion_actual
AFTER INSERT ON historial_graduaciones
FOR EACH ROW
BEGIN
  DECLARE fecha_max DATE;
  SELECT MAX(fecha)
  INTO fecha_max
  FROM historial_graduaciones
  WHERE persona_id = NEW.persona_id;

  IF NEW.fecha = fecha_max THEN
    UPDATE personas
    SET graduacion_actual = NEW.graduacion
    WHERE id = NEW.persona_id;
  END IF;
END$$

-- Trigger: UPDATE en historial_graduaciones
CREATE TRIGGER recalcular_graduacion_actual_update
AFTER UPDATE ON historial_graduaciones
FOR EACH ROW
BEGIN
  DECLARE grad VARCHAR(50);
  SELECT graduacion
  INTO grad
  FROM historial_graduaciones
  WHERE persona_id = NEW.persona_id
  ORDER BY fecha DESC
  LIMIT 1;

  UPDATE personas
  SET graduacion_actual = grad
  WHERE id = NEW.persona_id;
END$$

-- Trigger: DELETE en historial_graduaciones
CREATE TRIGGER recalcular_graduacion_actual_delete
AFTER DELETE ON historial_graduaciones
FOR EACH ROW
BEGIN
  DECLARE grad VARCHAR(50);
  SELECT graduacion
  INTO grad
  FROM historial_graduaciones
  WHERE persona_id = OLD.persona_id
  ORDER BY fecha DESC
  LIMIT 1;

  UPDATE personas
  SET graduacion_actual = grad
  WHERE id = OLD.persona_id;
END$$

-- Trigger: actualizar dojo_actual_id al insertar participación en dojo
CREATE TRIGGER actualizar_dojo_actual_insert
AFTER INSERT ON personas_por_dojo
FOR EACH ROW
BEGIN
  DECLARE dojo_ultimo INT;
  SELECT dojo_id
  INTO dojo_ultimo
  FROM personas_por_dojo
  WHERE persona_id = NEW.persona_id
  ORDER BY desde_fecha DESC
  LIMIT 1;

  UPDATE personas
  SET dojo_actual_id = dojo_ultimo
  WHERE id = NEW.persona_id;
END$$

-- Trigger: actualizar dojo_actual_id al hacer UPDATE
CREATE TRIGGER actualizar_dojo_actual_update
AFTER UPDATE ON personas_por_dojo
FOR EACH ROW
BEGIN
  DECLARE dojo_ultimo INT;
  SELECT dojo_id
  INTO dojo_ultimo
  FROM personas_por_dojo
  WHERE persona_id = NEW.persona_id
  ORDER BY desde_fecha DESC
  LIMIT 1;

  UPDATE personas
  SET dojo_actual_id = dojo_ultimo
  WHERE id = NEW.persona_id;
END$$

-- Trigger: actualizar dojo_actual_id al hacer DELETE
CREATE TRIGGER actualizar_dojo_actual_delete
AFTER DELETE ON personas_por_dojo
FOR EACH ROW
BEGIN
  DECLARE dojo_ultimo INT;
  SELECT dojo_id
  INTO dojo_ultimo
  FROM personas_por_dojo
  WHERE persona_id = OLD.persona_id
  ORDER BY desde_fecha DESC
  LIMIT 1;

  UPDATE personas
  SET dojo_actual_id = dojo_ultimo
  WHERE id = OLD.persona_id;
END$$

DELIMITER ;
