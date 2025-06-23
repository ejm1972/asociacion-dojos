<?php include('../includes/auth.php'); ?>
<?php include('../config/db.php'); ?>
<?php
if (!in_array($rol_actual, ['admin', 'dojo'])) {
    echo "Acceso denegado.";
    exit;
}
$dojos = [];
if ($rol_actual === 'admin') {
    $dojos = $pdo->query("SELECT * FROM dojos")->fetchAll();
} elseif ($rol_actual === 'dojo') {
    $stmt = $pdo->prepare("SELECT * FROM dojos WHERE id = ?");
    $stmt->execute([$dojo_actual]);
    $dojos = $stmt->fetchAll();
}
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $stmt = $pdo->prepare("INSERT INTO personas (nombre, apellido, email, telefono, dojo_id) VALUES (?, ?, ?, ?, ?)");
    $stmt->execute([
        $_POST['nombre'],
        $_POST['apellido'],
        $_POST['email'],
        $_POST['telefono'],
        $_POST['dojo_id']
    ]);
    echo "Persona registrada con éxito.";
}
?>

<a href="logout.php">Cerrar sesión</a>
<form method="post">
    <input name="nombre" placeholder="Nombre" required>
    <input name="apellido" placeholder="Apellido" required>
    <input name="email" placeholder="Email">
    <input name="telefono" placeholder="Teléfono">
    <select name="dojo_id">
        <?php foreach ($dojos as $dojo): ?>
            <option value="<?= $dojo['id'] ?>"><?= $dojo['nombre'] ?></option>
        <?php endforeach; ?>
    </select>
    <button type="submit">Registrar</button>
</form>
