<?php 
include('../includes/auth.php');
include('../config/db.php');

if ($rol_actual === 'dojo') {
    $stmt = $pdo->prepare("
        SELECT p.*, d.nombre AS dojo,
        (
            SELECT MAX(periodo_hasta) 
            FROM cuotas 
            WHERE persona_id = p.id
        ) AS ultima_cuota
        FROM personas p
        LEFT JOIN dojos d ON p.dojo_id = d.id
        WHERE p.dojo_id = ?
        ORDER BY p.apellido, p.nombre
    ");
    $stmt->execute([$dojo_actual]);
    $personas = $stmt->fetchAll();
} else {
    $personas = $pdo->query("
        SELECT p.*, d.nombre AS dojo,
        (
            SELECT MAX(periodo_hasta) 
            FROM cuotas 
            WHERE persona_id = p.id
        ) AS ultima_cuota
        FROM personas p
        LEFT JOIN dojos d ON p.dojo_id = d.id
        ORDER BY p.apellido, p.nombre
    ")->fetchAll();
}

ob_start();
?>

<h2>Listado de Personas</h2>
<p><a href="registrar_persona.php">➕ Crear nueva persona</a></p>
<table border="1">
    <tr>
        <th>Nombre</th>
        <th>Email</th>
        <th>Teléfono</th>
        <th>Dojo</th>
        <th>Estado</th>
        <th>Acciones</th>
    </tr>
    <?php foreach ($personas as $p): ?>
        <tr>
            <td><?= $p['nombre'] . ' ' . $p['apellido'] ?></td>
            <td><?= $p['email'] ?></td>
            <td><?= $p['telefono'] ?></td>
            <td><?= $p['dojo'] ?? 'Sin dojo' ?></td>
            <td>
                <?php
                $activa = isset($p['ultima_cuota']) && $p['ultima_cuota'] >= date('Y-m-d');
                echo $activa ? '✅ Activa' : '❌ Vencida';
                ?>
            </td>
            <td>
                <a href="editar_persona.php?id=<?= $p['id'] ?>">Editar</a> |
                <a href="eliminar_persona.php?id=<?= $p['id'] ?>" onclick="return confirm('¿Eliminar esta persona?')">Eliminar</a>
                <a href="editar.php?id=5" class="boton">Editar</a>
                <a href="eliminar.php?id=5" class="boton boton-eliminar">Eliminar</a>
            </td>
        </tr>
    <?php endforeach; ?>
</table>

<?php
$contenido = ob_get_clean();
include('../includes/layout.php');