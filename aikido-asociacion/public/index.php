<?php include('../includes/auth.php'); ?>
<?php include('../config/db.php'); ?>
<?php
$personas = $pdo->query("
    SELECT p.*, d.nombre AS dojo
    FROM personas p
    LEFT JOIN dojos d ON p.dojo_id = d.id
    ORDER BY p.apellido, p.nombre
")->fetchAll();
?>

<a href="logout.php">Cerrar sesión</a>
<table border="1">
    <tr><th>Nombre</th><th>Email</th><th>Teléfono</th><th>Dojo</th></tr>
    <?php foreach ($personas as $p): ?>
        <tr>
            <td><?= $p['nombre'] . ' ' . $p['apellido'] ?></td>
            <td><?= $p['email'] ?></td>
            <td><?= $p['telefono'] ?></td>
            <td><?= $p['dojo'] ?? 'Sin dojo' ?></td>
        </tr>
    <?php endforeach; ?>
</table>
