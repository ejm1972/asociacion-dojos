USE aikido_asociacion;

CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);

-- Usuario por defecto: admin / admin123
INSERT INTO usuarios (username, password)
VALUES ('admin', '$2y$10$VJ0USjJfpQFTBhZAfvYyxO5F3I9qY5bK61p.QczKXe9JDOBP/9nY2'); 
-- La contraseña 'admin123' fue hasheada con password_hash
