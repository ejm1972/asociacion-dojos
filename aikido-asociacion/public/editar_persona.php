<?php
include('../includes/auth.php');
include('../config/db.php');

if (!in_array($rol_actual, ['admin', 'dojo'])) {
    echo "Acceso denegado.";
    exit;
}

if (!isset($_GET['id'])) {
    header("Location: index.php");
    exit;
}

$id = (int)$_GET['id'];

// Obtener datos para llenar el formulario
$stmt = $pdo->prepare("SELECT * FROM personas WHERE id = ?");
$stmt->execute([$id]);
$persona = $stmt->fetch();

if (!$persona) {
    echo "Persona no encontrada.";
    exit;
}

// Guardar cambios
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $stmt = $pdo->prepare("UPDATE personas SET nombre = ?, apellido = ?, email = ?, telefono = ?, dojo_id = ? WHERE id = ?");
    $stmt->execute([
        $_POST['nombre'],
        $_POST['apellido'],
        $_POST['email'],
        $_POST['telefono'],
        $_POST['dojo_id'],
        $id
    ]);
    header("Location: index.php");
    exit;
}

// Obtener dojos para el select
$dojos = $pdo->query("SELECT * FROM dojos")->fetchAll();
?>

<h2>Editar Persona</h2>
<form method="post">
    <input name="nombre" value="<?= htmlspecialchars($persona['nombre']) ?>" required><br>
    <input name="apellido" value="<?= htmlspecialchars($persona['apellido']) ?>" required><br>
    <input name="email" value="<?= htmlspecialchars($persona['email']) ?>"><br>
    <input name="telefono" value="<?= htmlspecialchars($persona['telefono']) ?>"><br>
    <select name="dojo_id">
        <?php foreach ($dojos as $dojo): ?>
            <option value="<?= $dojo['id'] ?>" <?= $dojo['id'] == $persona['dojo_id'] ? 'selected' : '' ?>>
                <?= htmlspecialchars($dojo['nombre']) ?>
            </option>
        <?php endforeach; ?>
    </select><br>
    <button type="submit">Guardar cambios</button>
</form>