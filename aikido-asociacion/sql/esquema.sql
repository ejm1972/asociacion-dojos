-- Crear base de datos si no existe
CREATE DATABASE IF NOT EXISTS aikido_asociacion CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- Usar la base
USE aikido_asociacion;

-- A continuación crear el contenido
CREATE TABLE dojos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    ciudad VARCHAR(100),
    pais VARCHAR(100)
);

CREATE TABLE personas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    telefono VARCHAR(50),
    dojo_id INT,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (dojo_id) REFERENCES dojos(id)
);

CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    rol ENUM('admin', 'dojo', 'lector') NOT NULL DEFAULT 'lector',
    dojo_id INT,
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
