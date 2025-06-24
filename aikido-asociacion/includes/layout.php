<?php
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}
$current = basename($_SERVER['SCRIPT_NAME']);
$rol = $_SESSION['rol'] ?? null;
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Panel Aikido</title>
    <style>
        body {
            font-family: sans-serif;
            background: #f0f2f5;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        .panel {
            background: white;
            padding: 30px 40px;
            border-radius: 10px;
            box-shadow: 0 0 12px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 600px;
            box-sizing: border-box;
        }
        .panel h2 {
            margin-top: 0;
        }
        .menu {
            margin-bottom: 20px;
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            width: 100%;
            justify-content: flex-start;
        }
        .menu a {
            flex: 1 0 auto;
            text-decoration: none;
            color: #007bff;
            padding: 6px 10px;
            border-radius: 4px;
            text-align: center;
            min-width: 90px;
        }
        .menu a:hover {
            background-color: #e6f0ff;
        }
        .menu a.active {
            background-color: #007bff;
            color: white;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
            font-size: 0.95rem;
        }
        th, td {
            padding: 8px 12px;
            border: 1px solid #ddd;
            text-align: left;
        }
        th {
            background-color: #f5f5f5;
            font-weight: bold;
        }
        tr:nth-child(even) {
            background-color: #fafafa;
        }
        tr:hover {
            background-color: #eef;
            transition: background-color 0.2s ease;
        }
        .boton {
            display: inline-block;
            padding: 6px 12px;
            margin: 4px 0;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            font-size: 0.95rem;
            transition: background-color 0.2s ease;
        }

        .boton:hover {
            background-color: #0056b3;
        }

        .boton-eliminar {
            background-color: #dc3545;
        }

        .boton-eliminar:hover {
            background-color: #b02a37;
        }
        .alerta {
            padding: 10px 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            font-size: 0.95rem;
        }

        .alerta-error {
            background-color: #f8d7da;
            color: #842029;
            border: 1px solid #f5c2c7;
        }

        .alerta-exito {
            background-color: #d1e7dd;
            color: #0f5132;
            border: 1px solid #badbcc;
        }

        .alerta-info {
            background-color: #cff4fc;
            color: #055160;
            border: 1px solid #b6effb;
        }
    </style>
</head>
<body>
    <div class="panel">
        <?php if (isset($_SESSION['usuario'])): ?>
        <div class="menu">
            <a href="index.php" class="<?= $current === 'index.php' ? 'active' : '' ?>">👥 Personas</a>

            <?php if ($rol === 'admin'): ?>
                <a href="dojos.php" class="<?= $current === 'dojos.php' ? 'active' : '' ?>">🏯 Dojos</a>
                <a href="usuarios.php" class="<?= $current === 'usuarios.php' ? 'active' : '' ?>">👤 Usuarios</a>
            <?php endif; ?>

            <?php if (in_array($rol, ['admin', 'dojo'])): ?>
                <a href="cuotas.php" class="<?= $current === 'cuotas.php' ? 'active' : '' ?>">💰 Cuotas</a>
                <a href="grados.php" class="<?= $current === 'grados.php' ? 'active' : '' ?>">🎓 Grados</a>
            <?php endif; ?>

            <a href="logout.php">🚪 Cerrar sesión</a>
        </div>
        <?php endif; ?>

        <?= $contenido ?? '' ?>
    </div>
</body>
</html>
