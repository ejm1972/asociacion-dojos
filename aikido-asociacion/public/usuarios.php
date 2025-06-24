<?php 
include('../includes/auth.php');
include('../config/db.php');
require_once('../includes/rol.php');

requiere_rol(['admin']);

// obtener lista de usuarios
$usuarios = $pdo->query("
    SELECT u.*, d.nombre AS dojo_nombre 
    FROM usuarios u
    LEFT JOIN dojos d ON u.dojo_id = d.id
")->fetchAll();

ob_start();
?>

<h2>Usuarios</h2>
<p><a href="registrar_usuario.php">➕ Crear nuevo usuario</a></p>
<table border="1">
    <tr>
        <th>Usuario</th>
        <th>Rol</th>
        <th>Dojo</th>
        <th>Acción</th>
    </tr>
    <?php foreach ($usuarios as $u): ?>
        <tr>
            <td><?= $u['username'] ?></td>
            <td><?= $u['rol'] ?></td>
            <td><?= $u['dojo_nombre'] ?? '-' ?></td>
            <td><a href="editar_usuario.php?id=<?= $u['id'] ?>">Editar</a></td>
        </tr>
    <?php endforeach; ?>
</table>

<?php
$contenido = ob_get_clean();
include('../includes/layout.php');