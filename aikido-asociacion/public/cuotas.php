<?php include('../includes/auth.php'); ?>
<?php include('../config/db.php'); ?>

<?php
if (!in_array($rol_actual, ['admin', 'dojo'])) {
    echo "Acceso denegado.";
    exit;
}

// filtrar personas por rol
if ($rol_actual === 'admin') {
    $personas = $pdo->query("SELECT * FROM personas")->fetchAll();
} else {
    $stmt = $pdo->prepare("SELECT * FROM personas WHERE dojo_id = ?");
    $stmt->execute([$dojo_actual]);
    $personas = $stmt->fetchAll();
}

// guardar pago
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $stmt = $pdo->prepare("INSERT INTO cuotas (persona_id, fecha_pago, monto, periodo_desde, periodo_hasta, observacion)
        VALUES (?, ?, ?, ?, ?, ?)");
    $stmt->execute([
        $_POST['persona_id'],
        $_POST['fecha_pago'],
        $_POST['monto'],
        $_POST['periodo_desde'],
        $_POST['periodo_hasta'],
        $_POST['observacion']
    ]);
    echo "Pago registrado.";
}

// obtener cuotas
$cuotas = $pdo->query("
    SELECT c.*, p.nombre, p.apellido
    FROM cuotas c
    INNER JOIN personas p ON c.persona_id = p.id
    ORDER BY c.fecha_pago DESC
")->fetchAll();
?>

<h2>Registrar pago</h2>
<form method="post">
    <label>Persona:</label>
    <select name="persona_id" required>
        <?php foreach ($personas as $p): ?>
            <option value="<?= $p['id'] ?>"><?= $p['apellido'] . ', ' . $p['nombre'] ?></option>
        <?php endforeach; ?>
    </select><br>

    <label>Fecha de pago:</label>
    <input type="date" name="fecha_pago" required><br>

    <label>Monto:</label>
    <input type="number" step="0.01" name="monto" required><br>

    <label>Periodo desde:</label>
    <input type="date" name="periodo_desde" required><br>

    <label>Periodo hasta:</label>
    <input type="date" name="periodo_hasta" required><br>

    <label>Observación:</label>
    <input name="observacion"><br>

    <button type="submit">Guardar pago</button>
</form>

<h2>Historial de pagos</h2>
<table border="1">
    <tr><th>Persona</th><th>Fecha pago</th><th>Monto</th><th>Periodo</th><th>Obs</th></tr>
    <?php foreach ($cuotas as $c): ?>
        <tr>
            <td><?= $c['apellido'] . ', ' . $c['nombre'] ?></td>
            <td><?= $c['fecha_pago'] ?></td>
            <td><?= number_format($c['monto'], 2) ?></td>
            <td><?= $c['periodo_desde'] ?> a <?= $c['periodo_hasta'] ?></td>
            <td><?= $c['observacion'] ?></td>
        </tr>
    <?php endforeach; ?>
</table>
