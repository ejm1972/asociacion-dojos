<?php 
include('../includes/auth.php');
include('../config/db.php');
require_once('../includes/rol.php');

requiere_rol(['admin', 'dojo']);

if ($rol_actual === 'admin') {
    $personas = $pdo->query("SELECT * FROM personas")->fetchAll();
} else {
    $stmt = $pdo->prepare("SELECT * FROM personas WHERE dojo_id = ?");
    $stmt->execute([$dojo_actual]);
    $personas = $stmt->fetchAll();
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $stmt = $pdo->prepare("INSERT INTO grados (persona_id, grado, fecha_otorgamiento, observacion) VALUES (?, ?, ?, ?)");
    $stmt->execute([
        $_POST['persona_id'],
        $_POST['grado'],
        $_POST['fecha_otorgamiento'],
        $_POST['observacion']
    ]);
    echo "<p style='color:green;'>Grado registrado.</p>";
}

$historial = $pdo->query("
    SELECT g.*, p.nombre, p.apellido
    FROM grados g
    INNER JOIN personas p ON g.persona_id = p.id
    ORDER BY g.fecha_otorgamiento DESC
")->fetchAll();

ob_start();
?>

<h2>Registrar grado</h2>
<form method="post">
    <label>Persona:</label>
    <select name="persona_id" required>
        <?php foreach ($personas as $p): ?>
            <option value="<?= $p['id'] ?>"><?= htmlspecialchars($p['apellido'] . ', ' . $p['nombre']) ?></option>
        <?php endforeach; ?>
    </select><br>

    <label>Grado:</label>
    <input name="grado" placeholder="Ej: 3º Kyu, 1º Dan" required><br>

    <label>Fecha otorgamiento:</label>
    <input type="date" name="fecha_otorgamiento" required><br>

    <label>Observación:</label>
    <input name="observacion"><br>

    <button type="submit">Guardar</button>
</form>

<h2>Historial de grados</h2>
<table border="1">
    <tr><th>Persona</th><th>Grado</th><th>Fecha</th><th>Obs</th></tr>
    <?php foreach ($historial as $g): ?>
        <tr>
            <td><?= htmlspecialchars($g['apellido'] . ', ' . $g['nombre']) ?></td>
            <td><?= htmlspecialchars($g['grado']) ?></td>
            <td><?= htmlspecialchars($g['fecha_otorgamiento']) ?></td>
            <td><?= htmlspecialchars($g['observacion']) ?></td>
        </tr>
    <?php endforeach; ?>
</table>

<?php
$contenido = ob_get_clean();
include('../includes/layout.php');
