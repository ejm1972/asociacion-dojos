<?php
include('../includes/auth.php');
?>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Menú principal</title>
    <style>
        body {
            font-family: sans-serif;
        }
        ul.menu {
            list-style: none;
            padding: 0;
        }
        ul.menu li {
            margin: 8px 0;
        }
        ul.menu li a {
            text-decoration: none;
            background-color: #f0f0f0;
            padding: 10px 15px;
            border-radius: 6px;
            color: #333;
            display: inline-block;
            transition: background 0.3s;
        }
        ul.menu li a:hover {
            background-color: #ddd;
        }
    </style>
</head>
<body>
    <h2>Panel principal</h2>
    <p>Bienvenido, <?= htmlspecialchars($usuario_actual) ?> (rol: <?= htmlspecialchars($rol_actual) ?>)</p>

    <ul class="menu">
        <li><a href="index.php">📋 Personas</a></li>
        <li><a href="dojos.php">🏯 Dojos</a></li>
        <li><a href="usuarios.php">👤 Usuarios</a></li>
        <li><a href="cuotas.php">💰 Cuotas</a></li>
        <li><a href="grados.php">🎓 Grados</a></li>
        <li><a href="logout.php">🚪 Cerrar sesión</a></li>
    </ul>
</body>
</html>