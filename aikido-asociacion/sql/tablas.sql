SET FOREIGN_KEY_CHECKS = 0;

-- A continuación crear el contenido;
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    rol ENUM('admin', 'dojo', 'lector') NOT NULL DEFAULT 'lector',

    dojo_id INT,

    FOREIGN KEY (dojo_id) REFERENCES dojos(id)
)
-- ---------------------------------------------------------------------------------------------


-- Tabla dojos
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

-- Relación muchos a muchos: instructores en dojos
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
-- ---------------------------------------------------------------------------------------------


-- Tabla de personas
CREATE TABLE IF NOT EXISTS personas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    dni VARCHAR(15) UNIQUE,
    sexo ENUM('M', 'F', 'X'),
    fecha_nacimiento DATE,
    lugar_nacimiento VARCHAR(100),
    nacionalidad VARCHAR(50),
    estado_civil VARCHAR(50),
    
    telefono VARCHAR(50),
    email VARCHAR(100),
    fecha_verificacion_mail DATE,
    
    fecha_inscripcion DATE,
    
    domicilio_postal TEXT,
    impedimentos_fisicos TEXT,

    observaciones TEXT,

    imagen_dni TEXT,
    firma_digital TEXT,

    dojo_actual_id INT,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,

    graduacion_actual VARCHAR(50),

    FOREIGN KEY (dojo_id) REFERENCES dojos(id)
);

-- Participación general de personas en dojos (no instructores)
CREATE TABLE IF NOT EXISTS personas_por_dojo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    persona_id INT NOT NULL,
    dojo_id INT NOT NULL,
    desde_fecha DATE,
    hasta_fecha DATE,

    FOREIGN KEY (persona_id) REFERENCES personas(id) ON DELETE CASCADE,
    FOREIGN KEY (dojo_id) REFERENCES dojos(id) ON DELETE CASCADE
);

-- Registro de asistencia mensual
CREATE TABLE IF NOT EXISTS asistencia_mensual (
    id INT AUTO_INCREMENT PRIMARY KEY,
    persona_id INT NOT NULL,
    dojo_id INT NOT NULL,
    periodo_mes TINYINT NOT NULL,       -- 1 a 12
    periodo_anio SMALLINT NOT NULL,     -- Ej: 2025

    cantidad_clases INT,                -- opcional: cuántas veces asistió
    observaciones TEXT,                -- Ej: “asistió regularmente”, “solo 2 clases”, etc.

    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    registrado_por_id INT,              -- quién lo cargó (el responsable)

    FOREIGN KEY (persona_id) REFERENCES personas(id) ON DELETE CASCADE,
    FOREIGN KEY (dojo_id) REFERENCES dojos(id) ON DELETE CASCADE,
    FOREIGN KEY (registrado_por_id) REFERENCES personas(id) ON DELETE SET NULL,

    UNIQUE KEY uk_persona_periodo (persona_id, periodo_mes, periodo_anio)
);
-- ---------------------------------------------------------------------------------------------


-- Tabla cuotas pagadas
CREATE TABLE cuotas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    persona_id INT NOT NULL,
    fecha_pago DATE NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    
    periodo_mes TINYINT NOT NULL,         -- 1 a 12
    periodo_anio SMALLINT NOT NULL,       -- Ej: 2025
    metodo_pago VARCHAR(50),              -- efectivo, transferencia, débito, etc.
    observaciones TEXT,

    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    pagado BOOLEAN DEFAULT TRUE,
    vencida BOOLEAN DEFAULT FALSE,
    condonada BOOLEAN DEFAULT FALSE,

    -- Solo si querés conservar una referencia al dojo en que estaba inscrito
    dojo_id INT,

    FOREIGN KEY (persona_id) REFERENCES personas(id) ON DELETE CASCADE,
    FOREIGN KEY (dojo_id) REFERENCES dojos(id) ON DELETE SET NULL,
    UNIQUE KEY uk_persona_periodo (persona_id, periodo_mes, periodo_anio)
);
-- ---------------------------------------------------------------------------------------------


-- Historial de exámenes, graduciones
CREATE TABLE historial_graduaciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    persona_id INT NOT NULL,

    fecha DATE NOT NULL,
    graduacion_obtenida VARCHAR(50),
  
    dojo_id INT,
    instructor_id INT,
  
    observaciones TEXT,

    FOREIGN KEY (persona_id) REFERENCES personas(id) ON DELETE CASCADE,
    FOREIGN KEY (dojo_id) REFERENCES dojos(id) ON DELETE SET NULL,
    FOREIGN KEY (instructor_id) REFERENCES personas(id) ON DELETE SET NULL
);
-- ---------------------------------------------------------------------------------------------

SET FOREIGN_KEY_CHECKS = 1;