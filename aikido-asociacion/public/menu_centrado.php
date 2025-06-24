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
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background: #f9f9f9;
        }
        .panel {
            background: white;
            padding: 30px 40px;
            border-radius: 10px;
            box-shadow: 0 0 12px rgba(0,0,0,0.1);
            text-align: center;
        }
        .panel h2 {
            margin-top: 0;
        }
        ul.menu {
            list-style: none;
            padding: 0;
            margin-top: 20px;
        }
        ul.menu li {
            margin: 10px 0;
        }
        ul.menu li a {
            text-decoration: none;
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            border-radius: 6px;
            display: inline-block;
            transition: background 0.3s;
        }
        ul.menu li a:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="panel">
        <h2>Menú principal</h2>
        <p>Bienvenido, <?= htmlspecialchars($usuario_actual) ?> (rol: <?= htmlspecialchars($rol_actual) ?>)</p>

        <ul class="menu">
            <li><a href="index.php">📋 Personas</a></li>
            <li><a href="dojos.php">🏯 Dojos</a></li>
            <li><a href="usuarios.php">👤 Usuarios</a></li>
            <li><a href="cuotas.php">💰 Cuotas</a></li>
            <li><a href="grados.php">🎓 Grados</a></li>
            <li><a href="logout.php">🚪 Cerrar sesión</a></li>
        </ul>
    </div>
</body>
</html>