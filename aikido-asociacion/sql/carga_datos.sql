USE aikido_asociacion;

-- Usuario por defecto: admin / admin123
INSERT INTO usuarios (username, password, rol)
VALUES ('admin', '$2y$10$ArV7Fud75Zn5J01EXroNTOpUw2ALJ6mHbpRKCBfL6PMKq9CPrI5Ke', 'admin'); 
-- La contraseña 'admin123' fue hasheada con password_hash
