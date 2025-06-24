<?php
$current = basename($_SERVER['SCRIPT_NAME']);
$rol = $rol_actual ?? null;
?>
<!DOCTYPE html>
<html>
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
            padding: 20px 30px;
            border-radius: 10px;
            box-shadow: 0 0 12px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 80%;
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
            justify-content: flex-start; /* o space-between si querés más separación */
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
    </style>
</head>
<body>
    <div class="panel">
        <div class="menu">
            <a href="menu.php" class="<?= $current === 'menu.php' ? 'active' : '' ?>">🏠 Menú</a>
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

        <?= $contenido ?? '' ?>
    </div>
</body>
</html>
