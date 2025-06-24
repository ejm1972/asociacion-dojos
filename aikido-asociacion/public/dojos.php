<?php
include('../includes/auth.php');
include('../config/db.php');
require_once('../includes/rol.php');

requiere_rol(['admin']);

$dojos = $pdo->query("SELECT * FROM dojos ORDER BY nombre")->fetchAll();

ob_start();
?>

<h2>Listado de Dojos</h2>
<p><a href="registrar_dojo.php">➕ Crear nuevo dojo</a></p>
<table border="1" cellpadding="5">
    <tr>
        <th>ID</th>
        <th>Nombre</th>
        <th>Ciudad</th>
        <th>País</th>
        <th>Acciones</th>
    </tr>
    <?php foreach ($dojos as $dojo): ?>
        <tr>
            <td><?= $dojo['id'] ?></td>
            <td><?= htmlspecialchars($dojo['nombre']) ?></td>
            <td><?= htmlspecialchars($dojo['ciudad']) ?></td>
            <td><?= htmlspecialchars($dojo['pais']) ?></td>
            <td>
                <a href="editar_dojo.php?id=<?= $dojo['id'] ?>">Editar</a> |
                <a href="eliminar_dojo.php?id=<?= $dojo['id'] ?>" onclick="return confirm('¿Eliminar este dojo?')">Eliminar</a>
            </td>
        </tr>
    <?php endforeach; ?>
</table>

<?php
$contenido = ob_get_clean();
include('../includes/layout.php');