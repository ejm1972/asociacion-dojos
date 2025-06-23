# Proyecto Asociación de Dojos de Aikido

Este proyecto permite registrar personas y asociarlas a dojos dentro de una base de datos MySQL, utilizando PHP puro y una estructura de carpetas básica.

## Estructura
- `config/`: configuración de base de datos
- `public/`: archivos públicos del sitio
- `sql/`: script de base de datos

## Instalación
1. Importar el script `sql/esquema.sql` en tu servidor MySQL.
2. Configurar `config/db.php` con tus credenciales.
3. Acceder a `public/index.php` y `public/registrar.php` desde tu servidor local.

## Requisitos
- PHP 8+
- MySQL/MariaDB
- Servidor web (Apache, Nginx, etc.)

## Autor
Generado automáticamente.

# Proyecto Asociación de Dojos de Aikido

## Estructura
- `sql/esquema.sql`: estructura completa de base de datos
- `config/db.php`: conexión PDO
- `includes/auth.php`: control de login y rol
- `public/`: todas las páginas visibles

## Funcionalidades
- Login con roles: admin, dojo, lector
- Registro y visualización de personas por dojo
- Historial de cuotas y estado activo
- Historial técnico (grados kyu/dan)
- ABM de usuarios, personas y dojos