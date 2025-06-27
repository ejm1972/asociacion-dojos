-- Crear base de datos si no existe
CREATE DATABASE IF NOT EXISTS aikido_asociacion CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- Usar la base
USE aikido_asociacion;

-- A continuación crear el contenido
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    rol ENUM('admin', 'dojo', 'lector') NOT NULL DEFAULT 'lector',

    dojo_id INT,

    FOREIGN KEY (dojo_id) REFERENCES dojos(id)
);

-- Tabla dojos (extendida)
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

-- Tabla intermedia: instructores por dojo
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

CREATE TABLE personas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE,
    email VARCHAR(100),
    telefono VARCHAR(50),

    dojo_id INT,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (dojo_id) REFERENCES dojos(id)
);

CREATE TABLE cuotas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    persona_id INT NOT NULL,
    fecha_pago DATE NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    periodo_desde DATE NOT NULL,
    periodo_hasta DATE NOT NULL,
    observacion TEXT,
    
    FOREIGN KEY (persona_id) REFERENCES personas(id)
);

CREATE TABLE grados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    persona_id INT NOT NULL,
    grado VARCHAR(50) NOT NULL,
    fecha_otorgamiento DATE NOT NULL,
    observacion TEXT,

    FOREIGN KEY (persona_id) REFERENCES personas(id)
);

📦 1. Esquema completo: Tablas + claves foráneas

-- Tabla personas
CREATE TABLE IF NOT EXISTS personas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100),
    fecha_nacimiento DATE,
    email VARCHAR(100),
    telefono VARCHAR(100),
    observaciones TEXT
);

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

-- Tabla de personas
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
    firma_digital TEXT
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

-- Instructores por dojo (relación muchos a muchos con rol)
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

-- Datos generales de aikido
CREATE TABLE IF NOT EXISTS datos_aikido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    persona_id INT NOT NULL,
    graduacion_actual VARCHAR(50),
    examinador_fecha_examen VARCHAR(100),
    dojo_actual VARCHAR(100),
    instructor VARCHAR(100),
    antecedentes TEXT,
    cambios_producidos TEXT,
    observaciones_importantes TEXT,
    yudansha TEXT,
    clases INT,

    FOREIGN KEY (persona_id) REFERENCES personas(id) ON DELETE CASCADE
);

-- Historial de exámenes
CREATE TABLE IF NOT EXISTS examenes (
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

--🧾 Tabla cuotas
CREATE TABLE IF NOT EXISTS cuotas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    persona_id INT NOT NULL,
    fecha_pago DATE NOT NULL,
    periodo_mes TINYINT NOT NULL,         -- 1 a 12
    periodo_anio SMALLINT NOT NULL,       -- Ej: 2025
    monto DECIMAL(10,2) NOT NULL,
    metodo_pago VARCHAR(50),              -- efectivo, transferencia, débito, etc.
    observaciones TEXT,
    pagado BOOLEAN DEFAULT TRUE,

    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (persona_id) REFERENCES personas(id) ON DELETE CASCADE,
    UNIQUE KEY uk_persona_periodo (persona_id, periodo_mes, periodo_anio)
);

--🗃️ Paso 1: Tabla de historial de graduaciones
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

    -- Solo si querés conservar una referencia al dojo en que estaba inscrito
    dojo_id INT,

    FOREIGN KEY (persona_id) REFERENCES personas(id) ON DELETE CASCADE,
    FOREIGN KEY (dojo_id) REFERENCES dojos(id) ON DELETE SET NULL,
    UNIQUE KEY uk_persona_periodo (persona_id, periodo_mes, periodo_anio)
);

CREATE TABLE IF NOT EXISTS ingresos_asociacion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cuota_id INT,
    concepto VARCHAR(100), -- Ej: "Membresía mensual", "Cuota anual"
    fecha_ingreso DATE,
    monto DECIMAL(10,2),
    referencia_interna TEXT,

    FOREIGN KEY (cuota_id) REFERENCES cuotas(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS cuotas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    persona_id INT NOT NULL,
    fecha_pago DATE NOT NULL,
    periodo_mes TINYINT NOT NULL,         -- 1 a 12
    periodo_anio SMALLINT NOT NULL,       -- Ej: 2025
    monto DECIMAL(10,2) NOT NULL,
    metodo_pago VARCHAR(50),              -- efectivo, transferencia, etc.
    observaciones TEXT,
    pagado BOOLEAN DEFAULT TRUE,
    vencida BOOLEAN DEFAULT FALSE,
    condonada BOOLEAN DEFAULT FALSE,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (persona_id) REFERENCES personas(id) ON DELETE CASCADE,
    UNIQUE KEY uk_persona_periodo (persona_id, periodo_mes, periodo_anio)
);

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
